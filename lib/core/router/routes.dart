/// Definición de rutas de la aplicación.
///
/// Centraliza todas las rutas nombradas para navegación.
class Routes {
  Routes._();

  /// Ruta de la pantalla principal.
  static const String home = '/';

  /// Ruta del listado de productos.
  static const String products = '/products';

  /// Ruta del detalle de producto.
  static const String productDetail = '/product';

  /// Ruta de categorías.
  static const String categories = '/categories';

  /// Ruta del carrito de compras.
  static const String cart = '/cart';

  /// Ruta de checkout.
  static const String checkout = '/checkout';

  /// Ruta de confirmación de orden.
  static const String orderConfirmation = '/order-confirmation';

  /// Ruta de búsqueda.
  static const String search = '/search';

  /// Ruta del historial de órdenes.
  static const String orderHistory = '/orders';

  /// Genera la ruta para el detalle de un producto.
  static String productDetailPath(int id) => '/product/$id';
}
