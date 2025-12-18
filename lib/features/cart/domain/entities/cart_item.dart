import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Represents an item in the shopping cart.
///
/// Contains the product and selected quantity.
class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  /// Item product.
  final Product product;

  /// Quantity.
  final int quantity;

  /// Total item price (price * quantity).
  double get totalPrice => product.price * quantity;

  /// Creates a copy with provided values.
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}
