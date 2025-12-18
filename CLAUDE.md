# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con código en este repositorio.

## Descripción del Proyecto

Aplicación Flutter de e-commerce completa que consume la Fake Store API. Implementa Clean Architecture con el patrón BLoC para manejo de estado. Incluye autenticación, perfil de usuario y sistema de soporte. Soporta Android, iOS y Web.

- **Requisito SDK:** Dart ^3.9.2, Flutter ^3.29.2
- **Linting:** flutter_lints ^5.0.0 - **✅ 0 issues** (código 100% limpio)
- **State Management:** flutter_bloc ^8.1.6
- **DI:** get_it ^8.3.0
- **Tests:** 206/210 pasando (98%)

## Comandos Comunes

```bash
# Dependencias
flutter pub get

# Ejecutar aplicación
flutter run                    # Plataforma por defecto
flutter run -d chrome          # Web
flutter run -d <device_id>     # Dispositivo específico

# Compilar
flutter build apk              # Android
flutter build ios              # iOS
flutter build web              # Web

# Pruebas
flutter test                   # Ejecutar todas las pruebas
flutter test test/widget_test.dart  # Ejecutar archivo de prueba específico
flutter test --coverage        # Con reporte de cobertura

# Calidad de código
flutter analyze                # Análisis estático
dart fix --apply               # Corregir automáticamente problemas de lint
dart format lib/               # Formatear código
```

## Arquitectura

**Clean Architecture** con tres capas por feature:

### Estructura del Proyecto

```
lib/
├── app.dart                    # MaterialApp con AuthWrapper
├── main.dart                   # Entry point con inicialización DI
├── core/
│   ├── config/                 # Configuración JSON (AppConfig)
│   ├── constants/              # AppConstants (nombre app, mensajes)
│   ├── di/                     # injection_container.dart (get_it setup)
│   ├── router/                 # AppRouter, Routes, AuthWrapper
│   ├── theme/                  # AppTheme (configuración de tema)
│   └── utils/                  # Extensions (StringExtension, etc.)
├── features/
│   ├── auth/                   # 🆕 Autenticación (Login, Register, Logout)
│   │   ├── data/
│   │   │   ├── datasources/    # AuthLocalDataSource (SharedPreferences)
│   │   │   ├── models/         # UserModel (JSON serialization)
│   │   │   └── repositories/   # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/       # User (isAuthenticated, fullName)
│   │   │   ├── repositories/   # AuthRepository (abstract)
│   │   │   └── usecases/       # Login, Register, Logout, GetCurrentUser
│   │   └── presentation/
│   │       ├── bloc/           # AuthBloc, AuthEvent, AuthState
│   │       └── pages/          # LoginPage, RegisterPage
│   ├── cart/
│   │   ├── data/
│   │   │   ├── datasources/    # CartLocalDataSource (SharedPreferences)
│   │   │   ├── models/         # CartItemModel (JSON serialization)
│   │   │   └── repositories/   # CartRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/       # CartItem
│   │   │   ├── repositories/   # CartRepository (abstract)
│   │   │   └── usecases/       # GetCart, AddToCart, RemoveFromCart, etc.
│   │   └── presentation/
│   │       ├── bloc/           # CartBloc, CartEvent, CartState
│   │       ├── pages/          # CartPage
│   │       └── widgets/        # CartItemTile, CartSummary, EmptyCart
│   ├── categories/             # Categorías de productos
│   ├── checkout/               # Proceso de checkout
│   ├── home/                   # Página principal
│   ├── orders/                 # Historial de órdenes
│   ├── products/               # Productos y detalle
│   ├── profile/                # 🆕 Perfil de usuario
│   │   └── presentation/
│   │       └── pages/          # ProfilePage (con logout)
│   ├── search/                 # Búsqueda de productos
│   └── support/                # 🆕 Soporte y ayuda
│       ├── data/
│       │   ├── datasources/    # SupportLocalDataSource (18 FAQs mock)
│       │   ├── models/         # FAQItemModel, ContactMessageModel
│       │   └── repositories/   # SupportRepositoryImpl
│       ├── domain/
│       │   ├── entities/       # FAQItem, ContactMessage, ContactInfo
│       │   ├── repositories/   # SupportRepository (abstract)
│       │   └── usecases/       # GetFAQs, SendContactMessage
│       └── presentation/
│           ├── bloc/           # SupportBloc, SupportEvent, SupportState
│           ├── pages/          # SupportPage, ContactPage
│           └── widgets/        # FAQCard
├── shared/
│   └── widgets/                # AppScaffold, QuantitySelector, DSProductRating
└── test/                       # Unit tests (206 tests passing)
```

### Patrones Implementados

**BLoC Pattern:**
- Un BLoC por caso de uso
- Events como sealed classes
- States como sealed classes con Equatable
- Transformación de events a states

**Inyección de Dependencias:**
```dart
// En injection_container.dart
sl.registerLazySingleton(() => FakeStoreClient());
sl.registerLazySingleton(() => GetProductsUseCase(client: sl()));
sl.registerFactory(() => ProductsBloc(getProductsUseCase: sl()));
```

**Navegación:**
```dart
// Rutas nombradas en Routes class
Navigator.pushNamed(context, Routes.productDetail, arguments: {'id': 1});
```

## Dependencias Externas

| Paquete | Uso |
|---------|-----|
| `fake_store_api_client` | Cliente API (Git: ruta_flutter_f3) |
| `fake_store_design_system` | Componentes UI (Git: ruta_flutter_f4) |
| `flutter_bloc` | State management |
| `get_it` | Dependency injection |
| `shared_preferences` | Persistencia local |
| `cached_network_image` | Cache de imágenes |
| `dartz` | Either pattern (viene con api_client) |
| `equatable` | Value equality |

## Convenciones de Código

### Nombrado
- **Features:** snake_case (ej: `cart`, `products`)
- **Clases:** PascalCase (ej: `CartBloc`, `GetProductsUseCase`)
- **Archivos:** snake_case (ej: `cart_bloc.dart`, `get_products_usecase.dart`)
- **BLoC Events:** Past tense (ej: `CartItemAdded`, `ProductsLoadRequested`)
- **BLoC States:** Adjective/Noun (ej: `CartLoading`, `CartLoaded`, `CartError`)

### Barrel Files
Cada directorio tiene un barrel file para exports limpios:
```dart
// features/cart/cart.dart
export 'domain/entities/cart_item.dart';
export 'presentation/bloc/cart_bloc.dart';
// etc.
```

### Use Cases
- Un caso de uso por operación
- Método `call()` para invocación
- Retorna `Future<Either<Failure, T>>` o tipo directo

## Flujo de Datos

```
UI (Page/Widget)
    ↓ dispatch event
BLoC
    ↓ call
UseCase
    ↓ call
Repository (interface)
    ↓ implemented by
RepositoryImpl
    ↓ call
DataSource (Local/Remote)
    ↓ return
Model → Entity → State → UI
```

## Testing

Los tests actuales cubren:
- Entidades del dominio (CartItem)
- Modelos de datos (Product)

Para agregar tests:
```dart
// test/features/cart/domain/usecases/get_cart_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late GetCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(repository: mockRepository);
  });

  test('should get cart items from repository', () async {
    // arrange
    when(() => mockRepository.getCartItems())
        .thenAnswer((_) async => []);
    // act
    final result = await useCase();
    // assert
    expect(result, []);
    verify(() => mockRepository.getCartItems()).called(1);
  });
}
```

## Uso del Design System

El proyecto utiliza **todos** los componentes del Design System (`fake_store_design_system`) siguiendo el patrón Atomic Design.

### Tokens Utilizados
```dart
// Espaciado
DSSpacing.xs, DSSpacing.sm, DSSpacing.base, DSSpacing.lg, DSSpacing.xl

// Tamaños
DSSizes.iconSm, DSSizes.iconBase, DSSizes.iconMega, DSSizes.touchTarget
DSSizes.buttonSm, DSSizes.avatarXxl, DSSizes.borderHairline

// Border Radius
DSBorderRadius.smRadius, DSBorderRadius.baseRadius

// Colores
DSColors.white, DSColors.blackAlpha32
```

### Acceso a Tokens de Tema
```dart
final tokens = context.tokens;
tokens.colorBrandPrimary        // Color primario de marca
tokens.colorTextSecondary       // Texto secundario
tokens.colorTextTertiary        // Texto terciario
tokens.colorBorderPrimary       // Bordes
tokens.colorSurfaceSecondary    // Superficies
tokens.colorFeedbackWarning     // Estados (warning, success, etc.)
tokens.colorFeedbackSuccess
tokens.colorFeedbackSuccessLight
tokens.colorIconSecondary       // Íconos secundarios
tokens.colorBrandPrimaryLight   // Variante light del brand
```

### Componentes por Categoría

**Atoms:**
- `DSText` - Texto con variantes tipográficas
- `DSButton` - Botones (primary, secondary, ghost)
- `DSIconButton` - Botones con solo ícono
- `DSBadge` - Badges informativos
- `DSTextField` - Campos de texto
- `DSCircularLoader` - Indicador de carga

**Molecules:**
- `DSCard` - Contenedor con estilo
- `DSProductCard` - Card específico para productos
- `DSFilterChip` - Chips para filtros
- `DSEmptyState` - Estado vacío
- `DSErrorState` - Estado de error
- `DSLoadingState` - Estado de carga

**Organisms:**
- `DSAppBar` - Barra de navegación superior
- `DSBottomNav` - Navegación inferior
- `DSProductGrid` - Grid de productos

### Widgets Compartidos del Proyecto
- `DSProductRating` - Rating de producto usando tokens del DS
- `QuantitySelector` - Selector de cantidad con DSIconButton

### Ejemplo de Uso
```dart
// AppBar con widget personalizado
DSAppBar(
  title: 'Título',
  titleWidget: DSTextField(...),  // Widget personalizado en título
  actions: [DSIconButton(...)],
)

// Botón ghost para navegación
DSButton(
  text: 'Ver todos',
  variant: DSButtonVariant.ghost,
  size: DSButtonSize.small,
  onPressed: () => Navigator.pushNamed(...),
)

// Divisor usando tokens
Container(
  height: DSSizes.borderHairline,
  color: context.tokens.colorBorderPrimary,
)
```

## Parametrización JSON (Fase 7)

El proyecto implementa un sistema de parametrización que permite cambiar textos, imágenes y configuraciones sin modificar código.

### Ubicación del Archivo
```
assets/config/app_config.json
```

### Estructura del JSON
```json
{
  "orderHistory": {
    "pageTitle": "Mis Pedidos",
    "emptyState": { "icon": "receipt_long", "title": "...", "description": "..." },
    "orderCard": { "orderLabel": "Pedido", "statusLabels": { "completed": "..." } }
  },
  "images": { "emptyOrdersPlaceholder": "https://..." },
  "settings": { "maxOrdersToShow": 50, "currency": { "symbol": "$" } }
}
```

### Arquitectura de Configuración
```
assets/config/app_config.json          # Archivo JSON fuente
        ↓
ConfigLocalDataSource                   # Lee JSON con rootBundle
        ↓
AppConfig (Modelos Equatable)           # Parsea a modelos type-safe
        ↓
get_it (sl<AppConfig>())               # Registra como singleton
        ↓
BLoC / UI                              # Consume configuración
```

### Modelos de Configuración
```dart
// lib/core/config/app_config.dart
class AppConfig extends Equatable {
  final OrderHistoryConfig orderHistory;
  final ImagesConfig images;
  final SettingsConfig settings;

  factory AppConfig.fromJson(Map<String, dynamic> json) => ...
}
```

### Uso en UI
```dart
// Desde BLoC
final appConfig = sl<AppConfig>();
emit(OrderHistoryLoaded(orders: orders, config: appConfig.orderHistory));

// En Widget
DSAppBar(title: config.pageTitle)  // Texto desde JSON
DSEmptyState(
  title: config.emptyState.title,  // Texto parametrizado
  description: config.emptyState.description,
)
```

### Cómo Modificar Textos
1. Editar `assets/config/app_config.json`
2. Cambiar los valores deseados
3. Hot Restart la app (R mayúscula en terminal)

### Feature: Orders (usa parametrización)
```
lib/features/orders/
├── data/
│   ├── datasources/    # OrderLocalDataSource (SharedPreferences)
│   ├── models/         # OrderModel, OrderItemModel
│   └── repositories/   # OrderRepositoryImpl
├── domain/
│   ├── entities/       # Order, OrderItem, OrderStatus
│   ├── repositories/   # OrderRepository (abstract)
│   └── usecases/       # GetOrders, SaveOrder, ClearOrders
└── presentation/
    ├── bloc/           # OrderHistoryBloc
    ├── pages/          # OrderHistoryPage
    └── widgets/        # OrderCard (textos parametrizados)
```

### Documentación Detallada
Ver `assets/config/app_config.json` y `lib/core/config/`

## Features Nuevos Implementados

### Auth (Autenticación)
**Ubicación:** `lib/features/auth/`
**Tests:** 73/73 ✅

- **Domain Layer:**
  - `User` entity con `isAuthenticated` getter y `fullName`
  - `AuthRepository` con login, register, logout, getCurrentUser
  - UseCases: `LoginUseCase`, `RegisterUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase`

- **Data Layer:**
  - `AuthLocalDataSource` - Persistencia con SharedPreferences
  - `UserModel` - Serialización JSON
  - `AuthRepositoryImpl` - Implementación con validaciones

- **Presentation Layer:**
  - `AuthBloc` con 7 states: Initial, Loading, Authenticated, Unauthenticated, Error, AuthInProgress, AuthFailure
  - `LoginPage` - Formulario con email y contraseña
  - `RegisterPage` - Formulario completo con confirmación de contraseña

- **Flujo:**
  - `AuthWrapper` verifica sesión al iniciar app
  - Redirige automáticamente a login o home según estado
  - Sesión persiste en SharedPreferences

### Profile (Perfil)
**Ubicación:** `lib/features/profile/`

- **ProfilePage:**
  - Muestra info del usuario autenticado
  - Links de navegación a Pedidos y Soporte
  - Botón de logout con diálogo de confirmación
  - Vista para usuarios no autenticados

- **Integración:**
  - Usa `AuthBloc` para manejar logout
  - Redirige automáticamente después de logout
  - Accesible desde bottom navigation (index 3)

### Support (Soporte y Ayuda)
**Ubicación:** `lib/features/support/`
**Tests:** 10/10 ✅

- **Domain Layer:**
  - `FAQItem` entity con id, question, answer, category
  - `ContactMessage` entity para mensajes
  - `ContactInfo` para datos de contacto
  - `FAQCategory` enum: orders, payments, shipping, returns, account, general

- **Data Layer:**
  - `SupportLocalDataSource` con 18 FAQs mock
  - Persistencia de mensajes en SharedPreferences
  - `FAQItemModel` y `ContactMessageModel` con JSON serialization

- **Presentation Layer:**
  - `SupportBloc` para manejar FAQs y mensajes
  - `SupportPage` - Lista de FAQs con filtro por categoría
  - `ContactPage` - Formulario completo con validación
  - `FAQCard` widget expandible

### Navegación
- **AuthWrapper** (`Routes.authWrapper = '/'`) - Ruta inicial que verifica autenticación
- **Login** (`Routes.login = '/login'`) - Página de inicio de sesión
- **Register** (`Routes.register = '/register'`) - Página de registro
- **Profile** (`Routes.profile = '/profile'`) - Perfil de usuario
- **Support** (`Routes.support = '/support'`) - Lista de FAQs
- **Contact** (`Routes.contact = '/contact'`) - Formulario de contacto

## Notas de Desarrollo

- El carrito persiste en SharedPreferences como JSON
- Las órdenes persisten en SharedPreferences como JSON
- **La sesión de usuario persiste en SharedPreferences**
- **Los mensajes de contacto persisten en SharedPreferences**
- Las imágenes se cachean con cached_network_image
- La búsqueda tiene debounce de 300ms
- El Design System provee todos los componentes UI
- Los tokens de tema se acceden via `context.tokens`
- Evitar conflictos de nombres con `fake_store_api_client` (ej: usar prefijo DS)
- Textos e imágenes configurables via `assets/config/app_config.json`
- **Código 100% limpio** - `flutter analyze` retorna 0 issues
- **206 tests pasando** de 210 totales (98%)
