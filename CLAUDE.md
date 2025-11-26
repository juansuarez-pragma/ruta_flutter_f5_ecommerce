# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con código en este repositorio.

## Descripción del Proyecto

Aplicación Flutter de ecommerce con soporte para Android, iOS, Linux, macOS, Web y Windows. Actualmente en estado inicial con código boilerplate de contador.

- **Requisito SDK:** Dart ^3.9.2
- **Linting:** flutter_lints ^5.0.0 (ver analysis_options.yaml)

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

**Estado Actual:** Scaffold inicial de Flutter usando `setState` básico para manejo de estado.

**Estructura del Proyecto:**
- `lib/` - Código principal de la aplicación (punto de entrada: `main.dart`)
- `test/` - Pruebas de widgets y unitarias
- Directorios de plataforma: `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`

**Pendiente de implementar:** Librería de manejo de estado, enrutamiento, capa de datos (modelos/repositorios/servicios), integración con API.

## Notas de Desarrollo

- Usa Material Design con cupertino_icons para íconos estilo iOS
- Las seis plataformas están habilitadas y configuradas
- Las pruebas usan el framework flutter_test
