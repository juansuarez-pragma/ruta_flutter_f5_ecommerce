# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

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
