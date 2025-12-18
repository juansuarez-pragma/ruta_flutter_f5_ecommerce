/// Global application constants.
///
/// Centralizes constant values to avoid magic numbers/strings.
class AppConstants {
  AppConstants._();

  /// Application name.
  static const String appName = 'Fake Store';

  /// Maximum number of featured products on Home.
  static const int featuredProductsLimit = 6;

  /// Minimum allowed cart quantity.
  static const int minCartQuantity = 1;

  /// Maximum allowed cart quantity.
  static const int maxCartQuantity = 99;

  /// Key for cart persistence.
  static const String cartStorageKey = 'cart_items';

  /// Debounce duration for search.
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
