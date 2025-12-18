import 'package:ecommerce/features/cart/data/models/cart_item_model.dart';

/// Contrato para el datasource local del carrito.
abstract class CartLocalDataSource {
  /// Obtiene los items del carrito desde almacenamiento local.
  Future<List<CartItemModel>> getItems();

  /// Guarda los items del carrito en almacenamiento local.
  Future<void> saveItems(List<CartItemModel> items);

  /// Limpia el carrito del almacenamiento local.
  Future<void> clearItems();
}
