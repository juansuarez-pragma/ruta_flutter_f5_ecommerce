/// Application routes.
///
/// Centralizes all named routes for navigation.
class Routes {
  Routes._();

  /// Authentication check route (splash/initial).
  static const String authWrapper = '/';

  /// Login route.
  static const String login = '/login';

  /// Register route.
  static const String register = '/register';

  /// Home route (after authentication).
  static const String home = '/home';

  /// Products list route.
  static const String products = '/products';

  /// Product detail route.
  static const String productDetail = '/product';

  /// Categories route.
  static const String categories = '/categories';

  /// Cart route.
  static const String cart = '/cart';

  /// Checkout route.
  static const String checkout = '/checkout';

  /// Order confirmation route.
  static const String orderConfirmation = '/order-confirmation';

  /// Search route.
  static const String search = '/search';

  /// Order history route.
  static const String orderHistory = '/orders';

  /// Support route.
  static const String support = '/support';

  /// Support contact route.
  static const String contact = '/contact';

  /// User profile route.
  static const String profile = '/profile';

  /// Builds the route for a product detail page.
  static String productDetailPath(int id) => '/product/$id';
}
