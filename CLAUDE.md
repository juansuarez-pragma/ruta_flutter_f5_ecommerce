# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con código en este repositorio.

## Descripción del Proyecto

Aplicación Flutter de e-commerce que consume la Fake Store API. Implementa Clean Architecture con el patrón BLoC para manejo de estado. Soporta Android, iOS y Web.

- **Requisito SDK:** Dart ^3.9.2, Flutter ^3.29.2
- **Linting:** flutter_lints ^5.0.0 (ver analysis_options.yaml)
- **State Management:** flutter_bloc ^8.1.6
- **DI:** get_it ^8.0.3

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
├── app.dart                    # MaterialApp con configuración
├── main.dart                   # Entry point con inicialización DI
├── core/
│   ├── constants/              # AppConstants (nombre app, mensajes)
│   ├── di/                     # injection_container.dart (get_it setup)
│   ├── router/                 # AppRouter, Routes (named routes)
│   ├── theme/                  # AppTheme (configuración de tema)
│   └── utils/                  # Extensions (StringExtension, etc.)
├── features/
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
│   ├── categories/             # Similar structure (domain + presentation)
│   ├── checkout/               # Similar structure (presentation only)
│   ├── home/                   # Similar structure
│   ├── products/               # Similar structure
│   └── search/                 # Similar structure
├── shared/
│   └── widgets/                # AppScaffold, QuantitySelector
└── test/                       # Unit tests
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

## Notas de Desarrollo

- El carrito persiste en SharedPreferences como JSON
- Las imágenes se cachean con cached_network_image
- La búsqueda tiene debounce de 300ms
- El Design System provee todos los componentes UI (DSButton, DSCard, DSText, etc.)
- Los tokens de tema se acceden via `context.tokens`
