# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.2.0] - 2025-11-28

### Added

#### JSON Configuration (Phase 7)
Complete external configuration system that allows changing texts, images, and settings without modifying code.

**Core - Config:**
- `assets/config/app_config.json` - Central configuration file
- `lib/core/config/app_config.dart` - Public config barrel (stable import)
- `lib/core/config/models/*` - Config models split by responsibility
- `lib/core/config/config_datasource.dart` - JSON loading with caching

**Feature: Orders (Order History)**
New end-to-end feature following Clean Architecture:

*Data Layer:*
- `OrderLocalDataSource` - SharedPreferences persistence
- `OrderModel` / `OrderItemModel` - Modelos JSON
- `OrderRepositoryImpl` - Repository implementation

*Domain Layer:*
- `Order` / `OrderItem` - Domain entities
- `OrderStatus` - Enum with statuses (completed, pending, cancelled)
- `OrderRepository` - Abstract contract
- `GetOrdersUseCase` - Fetch history
- `SaveOrderUseCase` - Save a new order
- `ClearOrdersUseCase` - Clear history

*Presentation Layer:*
- `OrderHistoryBloc` - State management with BLoC
- `OrderHistoryPage` - Main page with JSON-driven texts
- `OrderCard` - Order widget with labels from JSON

**Checkout Integration:**
- Checkout now saves orders automatically before clearing the cart
- Navigation to order history from the confirmation page

**Routes:**
- `Routes.orderHistory` - New route `/orders`

### Documentation

- Updated `CLAUDE.md` with the JSON configuration section and Orders feature
- Updated `README.md` with new features and configuration section

---

## [1.1.0] - 2025-11-28

### Changed

#### Full Design System Integration
Replaced native Flutter widgets with Design System components to ensure visual consistency and validate the usage of each component.

**Home:**
- `Text` → `DSText` in the cart badge (home_page.dart)
- `TextButton` → `DSButton.ghost` in the categories section (categories_section.dart)
- `TextButton` → `DSButton.ghost` in the featured products section (featured_products_section.dart)

**Products:**
- Implemented `DSProductRating` for product rating (product_detail_page.dart)
- `IconButton` → `DSIconButton` in the detail AppBar
- Using `DSSizes.iconMega` for large icons

**Cart:**
- `Divider` → `Container` using Design System tokens (cart_summary.dart)
- `BorderRadius.circular` → `DSBorderRadius.smRadius` (cart_item_tile.dart)

**Categories:**
- Using `DSSizes.touchTarget` for icon sizes (category_tile.dart)
- `BorderRadius.circular` → `DSBorderRadius.baseRadius`
- Using `DSSizes.iconBase` for consistent sizing

**Search:**
- `AppBar` → `DSAppBar` with a custom `titleWidget` (search_page.dart)
- Using `DSSizes.iconMega` for the empty search icon

**Checkout:**
- `Divider` → `Container` using Design System tokens (checkout_page.dart)
- Overlay color → `DSColors.blackAlpha32`

**Order Confirmation:**
- Using `DSSizes.avatarXxl` and `DSSizes.iconMega` (order_confirmation_page.dart)
- Color tokens for success feedback

**Quantity Selector:**
- Using `DSSizes.buttonSm` for container width (quantity_selector.dart)

### Added

**Shared Widgets:**
- `DSProductRating` - Rating widget using Design System tokens
  - Star with warning color
  - Numeric rating using `DSText`
  - Optional review count

### Documentation
- Updated `CLAUDE.md` with Design System usage
- Updated `README.md` with Design System integration
- Documented all tokens and used components

---

## [1.0.0] - 2024-11-26

### Added

#### Core
- Dependency injection setup with `get_it`
- Named routes system with `AppRouter`
- Theme setup integrated with the Design System
- Centralized application constants
- Utility extensions (`StringExtension` for `titleCase`)

#### Feature: Home
- Home page with categories and featured products
- Category section with navigation
- Featured products section with grid
- Integration with `HomeBloc` for state management

#### Feature: Products
- Responsive product grid
- Category filtering
- Product details with image, description, and rating
- Add-to-cart button
- `ProductsBloc` and `ProductDetailBloc` for state

#### Feature: Cart
- Full shopping cart
- Add, remove, and update quantities
- Local persistence with `SharedPreferences`
- Cart summary with total
- Empty state with CTA
- Full Clean Architecture implementation (data, domain, presentation)

#### Feature: Categories
- List of all available categories
- Navigation to products filtered by category
- Custom icons per category type

#### Feature: Search
- Product search by name
- 300ms debounce to optimize requests
- Real-time results
- Empty and loading states

#### Feature: Checkout
- Checkout page with order summary
- Purchase confirmation
- Success page with order number
- Automatic cart clearing after purchase

#### Shared
- `AppScaffold` - Reusable scaffold with navigation
- `QuantitySelector` - Cart quantity selector

#### Testing
- Unit tests for the `CartItem` entity
- Tests for the `Product` model

### Dependencies
- `fake_store_api_client` - HTTP client for Fake Store API
- `fake_store_design_system` - Design System UI components
- `flutter_bloc ^8.1.6` - State management
- `get_it ^8.0.3` - Dependency injection
- `shared_preferences ^2.3.5` - Persistencia local
- `cached_network_image ^3.4.1` - Image caching
- `equatable ^2.0.7` - Value equality

## [0.0.1] - 2024-11-26

### Added
- Proyecto inicial de Flutter
- Cross-platform configuration (Android, iOS, Web)
- Estructura base del proyecto
