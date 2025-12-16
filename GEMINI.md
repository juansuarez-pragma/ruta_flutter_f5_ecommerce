## Descripción General del Proyecto

Esta es una aplicación de comercio electrónico desarrollada en Flutter que consume la [Fake Store API](https://fakestoreapi.com/). El proyecto sigue los principios de Clean Architecture y utiliza el patrón BLoC para la gestión del estado. Incluye funcionalidades como catálogo de productos, búsqueda, carrito de compras, proceso de pago, historial de pedidos, autenticación de usuarios, perfil de usuario y una sección de soporte. La aplicación está diseñada para ser multiplataforma, con soporte para Android, iOS y Web.

El proyecto se estructura en tres capas principales: `core`, `features` y `shared`.
- La capa `core` contiene funcionalidades compartidas como configuración, inyección de dependencias, enrutamiento y temas.
- La capa `features` está organizada por funcionalidades de la aplicación, y cada una tiene sus propias capas de `data`, `domain` y `presentation`.
- La capa `shared` contiene widgets compartidos.

La aplicación utiliza `flutter_bloc` para la gestión de estado, `get_it` para la inyección de dependencias, `shared_preferences` para el almacenamiento local y un sistema de diseño personalizado de un paquete externo.

## Compilación y Ejecución

### Prerrequisitos

-   Flutter SDK >= 3.29.2
-   Dart SDK >= 3.9.2

### Instalación

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/juansuarez-pragma/ruta_flutter_f5_ecommerce.git
    cd ruta_flutter_f5_ecommerce
    ```

2.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

### Ejecutar la Aplicación

-   **Ejecutar en modo de desarrollo:**
    ```bash
    flutter run
    ```

-   **Ejecutar en una plataforma específica:**
    ```bash
    flutter run -d chrome          # Web
    flutter run -d ios             # Simulador de iOS
    flutter run -d <android_device> # Dispositivo Android
    ```

### Compilar para Producción

```bash
flutter build web              # Web
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
```

## Convenciones de Desarrollo

### Calidad del Código

-   **Análisis Estático:** El proyecto usa `flutter_lints` para el análisis estático. Ejecuta `flutter analyze` para verificar si hay problemas.
-   **Formateo de Código:** Usa `dart format lib/` para formatear el código.
-   **Correcciones Automáticas:** Usa `dart fix --apply` para aplicar correcciones automáticas.

### Pruebas

El proyecto tiene un conjunto de pruebas completo con pruebas unitarias, pruebas de BLoC y pruebas de widgets.

-   **Ejecutar todas las pruebas:**
    ```bash
    flutter test
    ```

-   **Ejecutar pruebas con cobertura:**
    ```bash
    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html
    open coverage/html/index.html
    ```

### Estilo de Commits

El proyecto sigue la especificación de **Conventional Commits**.
