import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// Contrato para el repositorio del carrito.
///
/// Define las operaciones disponibles para gestionar el carrito.
abstract class CartRepository {
  /// Obtiene todos los items del carrito.
  Future<List<CartItem>> getCartItems();

  /// Agrega un item al carrito.
  ///
  /// Si el producto ya existe, incrementa la cantidad.
  Future<void> addItem(CartItem item);

  /// Elimina un item del carrito por ID de producto.
  Future<void> removeItem(int productId);

  /// Actualiza la cantidad de un item.
  Future<void> updateQuantity(int productId, int quantity);

  /// Limpia todos los items del carrito.
  Future<void> clearCart();
}
