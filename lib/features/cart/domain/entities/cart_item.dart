import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Representa un item en el carrito de compras.
///
/// Contiene el producto y la cantidad seleccionada.
class CartItem extends Equatable {
  /// Producto del item.
  final Product product;

  /// Cantidad del producto.
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  /// Precio total del item (precio * cantidad).
  double get totalPrice => product.price * quantity;

  /// Crea una copia del item con los valores proporcionados.
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}
