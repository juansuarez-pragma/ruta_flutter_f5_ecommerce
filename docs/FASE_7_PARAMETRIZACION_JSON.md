# FASE 7 - Parametrización de la App con JSON

## Objetivo

Implementar un sistema de parametrización que permita configurar textos, imágenes y ajustes de la aplicación a través de un archivo JSON leído como asset, sin necesidad de modificar el código fuente.

---

## 1. Creación del Archivo JSON

### Ubicación

```
assets/
└── config/
    └── app_config.json
```

### Estructura del JSON

El archivo JSON se organizó de forma jerárquica y semántica para facilitar su mantenimiento:

```json
{
  "orderHistory": {
    "pageTitle": "Mis Pedidos",
    "emptyState": {
      "icon": "receipt_long",
      "title": "No tienes pedidos",
      "description": "Cuando realices una compra, tus pedidos aparecerán aquí"
    },
    "orderCard": {
      "orderLabel": "Pedido",
      "dateLabel": "Fecha",
      "totalLabel": "Total",
      "itemsLabel": "productos",
      "statusLabels": {
        "completed": "Completado",
        "pending": "Pendiente",
        "cancelled": "Cancelado"
      }
    },
    "actions": {
      "viewDetails": "Ver detalles",
      "reorder": "Volver a pedir"
    }
  },
  "orderDetail": {
    "pageTitle": "Detalle del Pedido",
    "sections": {
      "summary": "Resumen",
      "products": "Productos",
      "shipping": "Envío"
    },
    "labels": {
      "orderId": "Número de pedido",
      "date": "Fecha de compra",
      "status": "Estado",
      "subtotal": "Subtotal",
      "shipping": "Envío",
      "total": "Total",
      "quantity": "Cantidad"
    },
    "shippingInfo": {
      "title": "Información de envío",
      "freeShipping": "Envío gratis",
      "estimatedDelivery": "Entrega estimada: 3-5 días hábiles"
    }
  },
  "images": {
    "emptyOrdersPlaceholder": "https://cdn-icons-png.flaticon.com/512/4076/4076432.png",
    "orderSuccessIcon": "https://cdn-icons-png.flaticon.com/512/5610/5610944.png"
  },
  "settings": {
    "maxOrdersToShow": 50,
    "dateFormat": "dd/MM/yyyy HH:mm",
    "currency": {
      "symbol": "$",
      "decimalDigits": 2,
      "locale": "es_CO"
    }
  }
}
```

### Principios de Diseño del JSON

1. **Agrupación por funcionalidad**: Cada sección de la app tiene su propio nodo (`orderHistory`, `orderDetail`)
2. **Separación de concerns**: Textos, imágenes y configuraciones en nodos distintos
3. **Nombres descriptivos**: Keys que indican claramente su propósito
4. **Escalabilidad**: Estructura que permite agregar nuevas secciones fácilmente

---

## 2. Implementación de la Lectura del JSON

### 2.1 Configuración de Assets en pubspec.yaml

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/config/
```

### 2.2 Modelos de Datos (Inmutables)

Se crearon modelos tipo-seguro usando Equatable para inmutabilidad:

**Archivo:** `lib/core/config/app_config.dart`

```dart
import 'package:equatable/equatable.dart';

/// Configuración principal de la aplicación.
class AppConfig extends Equatable {
  final OrderHistoryConfig orderHistory;
  final OrderDetailConfig orderDetail;
  final ImagesConfig images;
  final SettingsConfig settings;

  const AppConfig({
    required this.orderHistory,
    required this.orderDetail,
    required this.images,
    required this.settings,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      orderHistory: OrderHistoryConfig.fromJson(
        json['orderHistory'] as Map<String, dynamic>,
      ),
      orderDetail: OrderDetailConfig.fromJson(
        json['orderDetail'] as Map<String, dynamic>,
      ),
      images: ImagesConfig.fromJson(json['images'] as Map<String, dynamic>),
      settings: SettingsConfig.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [orderHistory, orderDetail, images, settings];
}
```

**Modelos anidados:**

```dart
/// Configuración del estado vacío.
class EmptyStateConfig extends Equatable {
  final String icon;
  final String title;
  final String description;

  const EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory EmptyStateConfig.fromJson(Map<String, dynamic> json) {
    return EmptyStateConfig(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [icon, title, description];
}

/// Configuración de tarjetas de orden con método helper.
class OrderCardConfig extends Equatable {
  final String orderLabel;
  final String dateLabel;
  final String totalLabel;
  final String itemsLabel;
  final Map<String, String> statusLabels;

  // ... constructor y fromJson ...

  /// Obtiene el label localizado para un estado.
  String getStatusLabel(String status) {
    return statusLabels[status] ?? status;
  }
}
```

### 2.3 DataSource para Lectura del Asset

**Archivo:** `lib/core/config/config_datasource.dart`

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ecommerce/core/config/app_config.dart';

/// DataSource para leer la configuración desde assets.
abstract class ConfigDataSource {
  Future<AppConfig> loadConfig();
}

/// Implementación que lee la configuración desde un asset JSON.
class ConfigLocalDataSource implements ConfigDataSource {
  static const String _configPath = 'assets/config/app_config.json';

  AppConfig? _cachedConfig;

  @override
  Future<AppConfig> loadConfig() async {
    // Cache para evitar lecturas repetidas
    if (_cachedConfig != null) {
      return _cachedConfig!;
    }

    // Leer el archivo JSON desde assets
    final jsonString = await rootBundle.loadString(_configPath);

    // Decodificar JSON a Map
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    // Crear modelo tipado
    _cachedConfig = AppConfig.fromJson(jsonMap);

    return _cachedConfig!;
  }

  /// Recarga la configuración (útil para desarrollo).
  Future<AppConfig> reloadConfig() async {
    _cachedConfig = null;
    return loadConfig();
  }
}
```

### 2.4 Registro en Inyección de Dependencias

**Archivo:** `lib/core/di/injection_container.dart`

```dart
Future<void> initDependencies() async {
  // ... otras dependencias ...

  // ============ Config (Fase 7 - Parametrización JSON) ============
  // 1. Registrar el DataSource
  sl.registerLazySingleton<ConfigDataSource>(() => ConfigLocalDataSource());

  // 2. Cargar la configuración al inicio
  final configDataSource = sl<ConfigDataSource>();
  final appConfig = await configDataSource.loadConfig();

  // 3. Registrar la configuración cargada como singleton
  sl.registerLazySingleton(() => appConfig);

  // ... resto de dependencias ...
}
```

---

## 3. Uso de los Datos Parametrizados

### 3.1 En Páginas (UI)

**Archivo:** `lib/features/orders/presentation/pages/order_history_page.dart`

```dart
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener configuración desde DI
    final appConfig = sl<AppConfig>();

    return BlocProvider(
      create: (_) => sl<OrderHistoryBloc>()
        ..add(const OrderHistoryLoadRequested()),
      child: Scaffold(
        // ✅ Título parametrizado desde JSON
        appBar: DSAppBar(title: appConfig.orderHistory.pageTitle),
        body: const _OrderHistoryBody(),
      ),
    );
  }
}
```

### 3.2 En Estados Vacíos

```dart
class _EmptyOrderHistory extends StatelessWidget {
  final OrderHistoryConfig config;

  const _EmptyOrderHistory({required this.config});

  @override
  Widget build(BuildContext context) {
    // ✅ Todos los textos vienen del JSON
    return DSEmptyState(
      icon: _getIconFromString(config.emptyState.icon),
      title: config.emptyState.title,
      description: config.emptyState.description,
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'receipt_long':
        return Icons.receipt_long;
      case 'shopping_bag':
        return Icons.shopping_bag;
      default:
        return Icons.receipt_long;
    }
  }
}
```

### 3.3 En Widgets Reutilizables

**Archivo:** `lib/features/orders/presentation/widgets/order_card.dart`

```dart
class OrderCard extends StatelessWidget {
  final Order order;
  final OrderHistoryConfig config;

  const OrderCard({
    super.key,
    required this.order,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DSCard(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Label "Pedido" parametrizado
              DSText(
                '${config.orderCard.orderLabel} #${order.id.split('-').last}',
                variant: DSTextVariant.titleSmall,
              ),
              // ✅ Estado con label parametrizado
              DSBadge(
                text: config.orderCard.getStatusLabel(order.status.key),
                type: _getBadgeType(order.status),
              ),
            ],
          ),
          // ... más contenido con textos parametrizados
        ],
      ),
    );
  }
}
```

### 3.4 En BLoCs (Pasar Configuración al Estado)

**Archivo:** `lib/features/orders/presentation/bloc/order_history_bloc.dart`

```dart
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final AppConfig _appConfig;

  OrderHistoryBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required AppConfig appConfig,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _appConfig = appConfig,
       super(const OrderHistoryInitial()) {
    on<OrderHistoryLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    OrderHistoryLoadRequested event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(const OrderHistoryLoading());

    try {
      final orders = await _getOrdersUseCase();
      // ✅ Pasar configuración al estado para uso en UI
      emit(OrderHistoryLoaded(
        orders: orders,
        config: _appConfig.orderHistory,
      ));
    } catch (e) {
      emit(OrderHistoryError('Error al cargar el historial: $e'));
    }
  }
}
```

---

## 4. Flujo de Datos Completo

```
┌─────────────────────────────────────────────────────────────────────┐
│                        INICIO DE LA APP                              │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  main.dart                                                          │
│  └── initDependencies()                                             │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  ConfigLocalDataSource.loadConfig()                                 │
│  └── rootBundle.loadString('assets/config/app_config.json')         │
│  └── json.decode(jsonString)                                        │
│  └── AppConfig.fromJson(jsonMap)                                    │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  GetIt (DI Container)                                               │
│  └── sl.registerLazySingleton(() => appConfig)                      │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│  UI (Widgets/Pages)                                                 │
│  └── final appConfig = sl<AppConfig>()                              │
│  └── appConfig.orderHistory.pageTitle                               │
│  └── appConfig.orderHistory.emptyState.title                        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. Cómo Modificar los Textos

### Paso 1: Editar el archivo JSON

```bash
# Abrir el archivo de configuración
code assets/config/app_config.json
```

### Paso 2: Cambiar los valores deseados

```json
{
  "orderHistory": {
    "pageTitle": "Historial de Compras",  // Antes: "Mis Pedidos"
    "emptyState": {
      "title": "Sin compras aún",          // Antes: "No tienes pedidos"
      "description": "¡Explora nuestros productos!"
    }
  }
}
```

### Paso 3: Reiniciar la aplicación

```bash
# Hot Restart (no Hot Reload) para recargar assets
# Presionar 'R' mayúscula en la terminal
# O desde VS Code: Ctrl+Shift+F5
```

---

## 6. Beneficios de la Parametrización

| Beneficio | Descripción |
|-----------|-------------|
| **Sin recompilación** | Cambiar textos no requiere rebuild de la app |
| **Localización fácil** | Base para implementar múltiples idiomas |
| **A/B Testing** | Cambiar textos para pruebas de UX |
| **Mantenimiento** | Textos centralizados, fáciles de encontrar |
| **Equipos** | Copywriters pueden editar sin conocer Dart |
| **Tipo-seguro** | Modelos Dart validan estructura del JSON |

---

## 7. Extensibilidad

### Agregar Nueva Sección Parametrizada

1. **Agregar al JSON:**
```json
{
  "newFeature": {
    "title": "Nueva Funcionalidad",
    "description": "Descripción parametrizada"
  }
}
```

2. **Crear modelo Dart:**
```dart
class NewFeatureConfig extends Equatable {
  final String title;
  final String description;

  // ... fromJson, props ...
}
```

3. **Agregar a AppConfig:**
```dart
class AppConfig extends Equatable {
  // ... campos existentes ...
  final NewFeatureConfig newFeature;

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      // ... existentes ...
      newFeature: NewFeatureConfig.fromJson(json['newFeature']),
    );
  }
}
```

4. **Usar en UI:**
```dart
final config = sl<AppConfig>();
DSText(config.newFeature.title);
```

---

## 8. Consideraciones de Producción

### Validación del JSON

```dart
Future<AppConfig> loadConfig() async {
  try {
    final jsonString = await rootBundle.loadString(_configPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return AppConfig.fromJson(jsonMap);
  } catch (e) {
    // Fallback a configuración por defecto
    return AppConfig.defaults();
  }
}
```

### Configuración Remota (Futuro)

```dart
abstract class ConfigDataSource {
  Future<AppConfig> loadConfig();
}

// Implementación local (actual)
class ConfigLocalDataSource implements ConfigDataSource { ... }

// Implementación remota (futura)
class ConfigRemoteDataSource implements ConfigDataSource {
  final HttpClient _client;

  @override
  Future<AppConfig> loadConfig() async {
    final response = await _client.get('/api/config');
    return AppConfig.fromJson(response.data);
  }
}
```

---

## 9. Archivos Creados/Modificados

### Nuevos Archivos

| Archivo | Propósito |
|---------|-----------|
| `assets/config/app_config.json` | Configuración parametrizada |
| `lib/core/config/app_config.dart` | Modelos de configuración |
| `lib/core/config/config_datasource.dart` | Lectura del JSON |
| `lib/core/config/config.dart` | Barrel file |
| `lib/features/orders/*` | Feature completo de historial |

### Archivos Modificados

| Archivo | Cambio |
|---------|--------|
| `pubspec.yaml` | Agregado assets/config/ |
| `lib/core/core.dart` | Export de config |
| `lib/core/di/injection_container.dart` | Registro de AppConfig |
| `lib/core/router/routes.dart` | Ruta orderHistory |
| `lib/core/router/app_router.dart` | Navegación a OrderHistoryPage |

---

## 10. Testing

### Test de Carga de Configuración

```dart
void main() {
  test('AppConfig.fromJson should parse JSON correctly', () {
    final json = {
      'orderHistory': {
        'pageTitle': 'Test Title',
        'emptyState': {
          'icon': 'receipt_long',
          'title': 'Empty',
          'description': 'No orders',
        },
        // ... resto del JSON
      },
      // ... otras secciones
    };

    final config = AppConfig.fromJson(json);

    expect(config.orderHistory.pageTitle, 'Test Title');
    expect(config.orderHistory.emptyState.title, 'Empty');
  });
}
```

---

**Fecha de implementación:** 2025-11-28
**Versión:** 1.2.0
**Autor:** Implementado con Claude Code
