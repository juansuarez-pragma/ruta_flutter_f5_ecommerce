# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## Project Overview

Full-featured Flutter e-commerce application consuming the Fake Store API. The project follows Clean Architecture and uses the BLoC pattern for state management. It includes authentication, user profile, and a support system. Targets Android, iOS, and Web.

- **SDK requirement:** Dart ^3.9.2, Flutter ^3.29.2
- **Linting:** `flutter_lints ^5.0.0` (0 issues)
- **State management:** `flutter_bloc ^8.1.6`
- **DI:** `get_it ^8.3.0`

## Common Commands

```bash
# Dependencies
flutter pub get

# Run
flutter run                    # Default platform
flutter run -d chrome          # Web
flutter run -d <device_id>     # Specific device

# Build
flutter build apk              # Android
flutter build ios              # iOS
flutter build web              # Web

# Tests
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter test --coverage        # With coverage report

# Code quality
flutter analyze                # Static analysis
dart fix --apply               # Apply automatic fixes
dart format lib/               # Format code
```

## Architecture

Clean Architecture with three layers per feature (`data`, `domain`, `presentation`).

### Project Structure

```
lib/
├── app.dart                    # MaterialApp + AuthWrapper
├── main.dart                   # Entry point + DI bootstrap
├── core/
│   ├── config/                 # JSON configuration (AppConfig)
│   ├── constants/              # AppConstants (app name, keys, etc.)
│   ├── di/                     # injection_container.dart (get_it setup)
│   ├── router/                 # AppRouter, Routes, AuthWrapper
│   ├── theme/                  # AppTheme (Design System integration)
│   └── utils/                  # Extensions and utilities
├── features/
│   ├── auth/                   # Authentication (Login/Register/Logout)
│   ├── cart/                   # Shopping cart
│   ├── categories/             # Product categories
│   ├── checkout/               # Checkout flow
│   ├── home/                   # Home page
│   ├── orders/                 # Order history
│   ├── products/               # Products and product detail
│   ├── profile/                # User profile
│   ├── search/                 # Search
│   └── support/                # Support (FAQs + contact)
└── shared/
    └── widgets/                # Shared widgets (AppScaffold, QuantitySelector, etc.)
```

### Patterns

**BLoC pattern**
- One BLoC per feature/use case flow
- Sealed classes for events and states
- Equatable-based state comparison

**Dependency injection**
```dart
// In injection_container.dart
sl.registerLazySingleton(() => FakeStoreClient());
sl.registerLazySingleton(() => GetProductsUseCase(client: sl()));
sl.registerFactory(() => ProductsBloc(getProductsUseCase: sl()));
```

**Navigation**
```dart
Navigator.pushNamed(context, Routes.productDetail, arguments: {'id': 1});
```

## External Dependencies

| Package | Usage |
|---------|-------|
| `fake_store_api_client` | API client (from Phase 3) |
| `fake_store_design_system` | UI components & tokens (from Phase 4) |
| `flutter_bloc` | State management |
| `get_it` | Dependency injection |
| `shared_preferences` | Local persistence |
| `cached_network_image` | Image caching |
| `dartz` | Either pattern |
| `equatable` | Value equality |

## Code Conventions

### Naming
- **Features:** `snake_case` (e.g., `cart`, `products`)
- **Classes:** `PascalCase` (e.g., `CartBloc`, `GetProductsUseCase`)
- **Files:** `snake_case` (e.g., `cart_bloc.dart`, `get_products_usecase.dart`)
- **BLoC events:** past tense (e.g., `CartItemAdded`, `ProductsLoadRequested`)
- **BLoC states:** adjective/noun (e.g., `CartLoading`, `CartLoaded`, `CartError`)

### Barrel Files
Each feature exposes a barrel for clean exports:
```dart
// features/cart/cart.dart
export 'domain/entities/cart_item.dart';
export 'presentation/bloc/cart_bloc.dart';
```

### Use Cases
- One use case per operation
- Use `call()` for invocation
- Prefer `Future<Either<Failure, T>>` or direct types where appropriate

### Avoid “God Files”
If a file starts accumulating multiple unrelated models/classes, split by responsibility and expose a stable barrel (example: `lib/core/config/app_config.dart`).

## Data Flow

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

The test suite includes:
- Domain entities (e.g., `CartItem`)
- Data models
- BLoCs (via `bloc_test`)

Example:
```dart
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
    when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);
    final result = await useCase();
    expect(result, []);
    verify(() => mockRepository.getCartItems()).called(1);
  });
}
```

## Design System Usage

The project uses `fake_store_design_system` components following Atomic Design.

Tokens are accessed through `context.tokens`:
```dart
final tokens = context.tokens;
tokens.colorBrandPrimary
tokens.colorTextSecondary
tokens.colorBorderPrimary
```

## JSON Configuration (Phase 7)

Texts and images are configurable via:
- `assets/config/app_config.json`

Config loading:
- `ConfigDataSource` reads the JSON from assets and caches it.
- `AppConfig` models are in `lib/core/config/models/` and are exported via `lib/core/config/app_config.dart`.

How to modify texts/images:
1. Edit `assets/config/app_config.json`
2. Update values
3. Hot restart (capital `R` in the terminal)

## Feature Notes

**Auth**
- Local auth backed by SharedPreferences (no external API dependency)
- Pages: Login, Register

**Profile**
- Shows the authenticated user info
- Navigation shortcuts to Orders and Support
- Logout with confirmation

**Support**
- FAQs + category filtering
- Contact form with local persistence for submitted messages

**Orders**
- Local order history via SharedPreferences
- UI texts driven by JSON configuration

## Development Notes

- Cart persists in SharedPreferences as JSON
- Orders persist in SharedPreferences as JSON
- User session persists in SharedPreferences
- Contact messages persist in SharedPreferences
- Search uses 300ms debounce
- Theme tokens are accessed via `context.tokens`
- Keep `flutter analyze` clean and the test suite green

