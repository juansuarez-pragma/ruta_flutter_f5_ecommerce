## Project Overview

This is a Flutter e-commerce application that consumes the [Fake Store API](https://fakestoreapi.com/). The project follows Clean Architecture principles and uses the BLoC pattern for state management. It includes features such as a product catalog, search, shopping cart, checkout flow, order history, user authentication, user profile, and a support section. The app is designed to be cross-platform, supporting Android, iOS, and Web.

The project is organized into three main areas: `core`, `features`, and `shared`.
- The `core` layer contains shared functionality such as configuration, dependency injection, routing, and theming.
- The `features` layer is organized by app capability, and each feature has its own `data`, `domain`, and `presentation` layers.
- The `shared` layer contains shared widgets.

The application uses `flutter_bloc` for state management, `get_it` for dependency injection, `shared_preferences` for local storage, and a custom Design System from an external package.

## Build and Run

### Prerequisites

-   Flutter SDK >= 3.29.2
-   Dart SDK >= 3.9.2

### Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/juansuarez-pragma/ruta_flutter_f5_ecommerce.git
    cd ruta_flutter_f5_ecommerce
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

### Run the App

-   **Run in development mode:**
    ```bash
    flutter run
    ```

-   **Run on a specific platform:**
    ```bash
    flutter run -d chrome          # Web
    flutter run -d ios             # iOS simulator
    flutter run -d <android_device> # Android device
    ```

### Build for Production

```bash
flutter build web              # Web
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
```

## Development Conventions

### Code Quality

-   **Static analysis:** The project uses `flutter_lints`. Run `flutter analyze` to check for issues.
-   **Formatting:** Run `dart format lib/` to format code.
-   **Automatic fixes:** Run `dart fix --apply` to apply automatic fixes.

### Testing

The project includes a test suite with unit tests, BLoC tests, and widget tests.

-   **Run all tests:**
    ```bash
    flutter test
    ```

-   **Run tests with coverage:**
    ```bash
    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html
    open coverage/html/index.html
    ```

### Commit Style

This project follows the **Conventional Commits** specification.
