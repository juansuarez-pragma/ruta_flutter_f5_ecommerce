/// Constantes globales de la aplicación.
///
/// Centraliza todos los valores constantes para evitar valores mágicos.
class AppConstants {
  AppConstants._();

  /// Nombre de la aplicación.
  static const String appName = 'Fake Store';

  /// Número máximo de productos destacados en home.
  static const int featuredProductsLimit = 6;

  /// Cantidad mínima de producto en carrito.
  static const int minCartQuantity = 1;

  /// Cantidad máxima de producto en carrito.
  static const int maxCartQuantity = 99;

  /// Key para persistencia del carrito.
  static const String cartStorageKey = 'cart_items';

  /// Duración del debounce para búsqueda.
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
