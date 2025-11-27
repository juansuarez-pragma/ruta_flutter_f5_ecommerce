# Fake Store E-commerce

Aplicación Flutter de e-commerce completa que consume la [Fake Store API](https://fakestoreapi.com/). Desarrollada siguiendo Clean Architecture y el patrón BLoC para manejo de estado.

## Capturas de Pantalla

| Home | Productos | Carrito |
|------|-----------|---------|
| Lista de categorías y productos destacados | Grid de productos con filtros | Carrito con persistencia local |

## Características

- **Catálogo de productos** - Navegación por categorías y listado completo
- **Búsqueda** - Búsqueda de productos con debounce
- **Detalle de producto** - Vista detallada con rating y descripción
- **Carrito de compras** - Agregar, eliminar y modificar cantidades
- **Persistencia local** - El carrito se guarda localmente
- **Checkout** - Flujo de compra con confirmación de orden
- **Multiplataforma** - Android, iOS, Web

## Arquitectura

El proyecto sigue **Clean Architecture** con separación en tres capas:

```
lib/
├── app.dart                    # MaterialApp principal
├── main.dart                   # Entry point
├── core/                       # Capa core compartida
│   ├── constants/              # Constantes de la aplicación
│   ├── di/                     # Inyección de dependencias (get_it)
│   ├── router/                 # Configuración de rutas
│   ├── theme/                  # Tema de la aplicación
│   └── utils/                  # Extensiones y utilidades
├── features/                   # Features de la aplicación
│   ├── cart/                   # Carrito de compras
│   │   ├── data/               # Datasources, models, repositories impl
│   │   ├── domain/             # Entities, repositories, use cases
│   │   └── presentation/       # BLoC, pages, widgets
│   ├── categories/             # Listado de categorías
│   ├── checkout/               # Proceso de checkout
│   ├── home/                   # Página principal
│   ├── products/               # Productos y detalle
│   └── search/                 # Búsqueda de productos
└── shared/                     # Widgets compartidos
    └── widgets/
```

### Patrón BLoC

Cada feature implementa el patrón BLoC (Business Logic Component):

- **Events** - Acciones del usuario (sealed classes)
- **States** - Estados de la UI (sealed classes)
- **BLoC** - Lógica de negocio que transforma events en states

### Inyección de Dependencias

Se utiliza `get_it` para la inyección de dependencias:

```dart
// Registrar
sl.registerLazySingleton(() => GetProductsUseCase(client: sl()));

// Usar
final useCase = sl<GetProductsUseCase>();
```

## Dependencias Externas

Este proyecto consume dos paquetes desarrollados en fases anteriores:

| Paquete | Descripción | Repositorio |
|---------|-------------|-------------|
| `fake_store_api_client` | Cliente HTTP para Fake Store API | [ruta_flutter_f3](https://github.com/juansuarez-pragma/ruta_flutter_f3) |
| `fake_store_design_system` | Design System con componentes UI | [ruta_flutter_f4](https://github.com/juansuarez-pragma/ruta_flutter_f4) |

## Requisitos

- Flutter SDK >= 3.29.2
- Dart SDK >= 3.9.2

## Instalación

```bash
# Clonar repositorio
git clone https://github.com/juansuarez-pragma/ruta_flutter_f5_ecommerce.git
cd ruta_flutter_f5_ecommerce

# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run
```

## Comandos Útiles

```bash
# Ejecutar en diferentes plataformas
flutter run -d chrome          # Web
flutter run -d ios             # iOS Simulator
flutter run -d <android_device> # Android

# Compilar para producción
flutter build web              # Web
flutter build apk              # Android
flutter build ios              # iOS

# Pruebas
flutter test                   # Ejecutar tests
flutter test --coverage        # Con cobertura

# Calidad de código
flutter analyze                # Análisis estático
dart format lib/               # Formatear código
dart fix --apply               # Aplicar fixes automáticos
```

## Estructura de Features

### Home
- Muestra categorías disponibles
- Lista productos destacados
- Navegación al catálogo completo

### Products
- Grid de productos con imagen, precio y rating
- Filtrado por categoría
- Vista detallada del producto
- Agregar al carrito

### Cart
- Lista de productos en el carrito
- Modificar cantidades
- Eliminar productos
- Resumen con total
- Persistencia con SharedPreferences

### Search
- Búsqueda por nombre de producto
- Debounce de 300ms para optimizar requests
- Resultados en tiempo real

### Checkout
- Resumen de la orden
- Confirmación de compra
- Página de éxito con número de orden

## Testing

```bash
# Ejecutar todos los tests
flutter test

# Tests con cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Contribuir

1. Fork el repositorio
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -m 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## Licencia

Este proyecto es parte de la Ruta de Aprendizaje Flutter de Pragma.

## Autor

Juan Carlos Suárez - [@juansuarez-pragma](https://github.com/juansuarez-pragma)
