import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// Contract for the cart repository.
///
/// Defines available operations to manage the cart.
abstract class CartRepository {
  /// Returns all cart items.
  Future<List<CartItem>> getCartItems();

  /// Adds an item to the cart.
  ///
  /// If the product already exists, increments the quantity.
  Future<void> addItem(CartItem item);

  /// Removes a cart item by product id.
  Future<void> removeItem(int productId);

  /// Updates an item's quantity.
  Future<void> updateQuantity(int productId, int quantity);

  /// Clears all items from the cart.
  Future<void> clearCart();
}
