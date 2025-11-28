# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.1.0] - 2025-11-28

### Cambiado

#### Integración Completa del Design System
Se reemplazaron todos los widgets nativos de Flutter por componentes del Design System para garantizar consistencia visual y evaluar la pertinencia de cada componente.

**Home:**
- `Text` → `DSText` en badge del carrito (home_page.dart)
- `TextButton` → `DSButton.ghost` en sección de categorías (categories_section.dart)
- `TextButton` → `DSButton.ghost` en sección de productos destacados (featured_products_section.dart)

**Products:**
- Implementación de `DSProductRating` para rating de producto (product_detail_page.dart)
- `IconButton` → `DSIconButton` en AppBar de detalle
- Uso de `DSSizes.iconMega` para íconos grandes

**Cart:**
- `Divider` → `Container` con tokens del DS (cart_summary.dart)
- `BorderRadius.circular` → `DSBorderRadius.smRadius` (cart_item_tile.dart)

**Categories:**
- Uso de `DSSizes.touchTarget` para tamaños de íconos (category_tile.dart)
- `BorderRadius.circular` → `DSBorderRadius.baseRadius`
- Uso de `DSSizes.iconBase` para tamaños consistentes

**Search:**
- `AppBar` → `DSAppBar` con `titleWidget` personalizado (search_page.dart)
- Uso de `DSSizes.iconMega` para ícono de búsqueda vacía

**Checkout:**
- `Divider` → `Container` con tokens del DS (checkout_page.dart)
- Overlay color → `DSColors.blackAlpha32`

**Order Confirmation:**
- Uso de `DSSizes.avatarXxl` y `DSSizes.iconMega` (order_confirmation_page.dart)
- Tokens de color para feedback de éxito

**Quantity Selector:**
- Uso de `DSSizes.buttonSm` para ancho del contenedor (quantity_selector.dart)

### Agregado

**Shared Widgets:**
- `DSProductRating` - Widget para mostrar rating de productos usando tokens del DS
  - Muestra estrella con color de warning
  - Rating numérico con `DSText`
  - Conteo de reseñas opcional

### Documentación
- Actualizado CLAUDE.md con sección de uso del Design System
- Actualizado README.md con sección de integración del Design System
- Documentados todos los tokens y componentes utilizados

---

## [1.0.0] - 2024-11-26

### Agregado

#### Core
- Configuración de inyección de dependencias con `get_it`
- Sistema de rutas nombradas con `AppRouter`
- Configuración de tema integrada con Design System
- Constantes de aplicación centralizadas
- Extensiones de utilidad (`StringExtension` para `titleCase`)

#### Feature: Home
- Página principal con categorías y productos destacados
- Sección de categorías con navegación
- Sección de productos destacados con grid
- Integración con `HomeBloc` para manejo de estado

#### Feature: Products
- Listado de productos en grid responsive
- Filtrado por categoría
- Vista detallada de producto con imagen, descripción y rating
- Botón para agregar al carrito
- `ProductsBloc` y `ProductDetailBloc` para estado

#### Feature: Cart
- Carrito de compras completo
- Agregar, eliminar y modificar cantidades
- Persistencia local con `SharedPreferences`
- Resumen de carrito con total
- Estado vacío con llamada a la acción
- Implementación completa de Clean Architecture (data, domain, presentation)

#### Feature: Categories
- Listado de todas las categorías disponibles
- Navegación a productos filtrados por categoría
- Íconos personalizados por tipo de categoría

#### Feature: Search
- Búsqueda de productos por nombre
- Debounce de 300ms para optimizar requests
- Resultados en tiempo real
- Estado vacío y de carga

#### Feature: Checkout
- Página de checkout con resumen de orden
- Confirmación de compra
- Página de éxito con número de orden
- Limpieza automática del carrito post-compra

#### Shared
- `AppScaffold` - Scaffold reutilizable con navegación
- `QuantitySelector` - Selector de cantidad para carrito

#### Testing
- Tests unitarios para entidad `CartItem`
- Tests para modelo `Product`

### Dependencias
- `fake_store_api_client` - Cliente HTTP para Fake Store API
- `fake_store_design_system` - Design System con componentes UI
- `flutter_bloc ^8.1.6` - State management
- `get_it ^8.0.3` - Dependency injection
- `shared_preferences ^2.3.5` - Persistencia local
- `cached_network_image ^3.4.1` - Cache de imágenes
- `equatable ^2.0.7` - Value equality

## [0.0.1] - 2024-11-26

### Agregado
- Proyecto inicial de Flutter
- Configuración multiplataforma (Android, iOS, Web)
- Estructura base del proyecto
