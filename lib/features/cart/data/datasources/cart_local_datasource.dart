import 'package:ecommerce/features/cart/data/models/cart_item_model.dart';

/// Contract for the cart local data source.
abstract class CartLocalDataSource {
  /// Returns cart items from local storage.
  Future<List<CartItemModel>> getItems();

  /// Saves cart items to local storage.
  Future<void> saveItems(List<CartItemModel> items);

  /// Clears the cart from local storage.
  Future<void> clearItems();
}
