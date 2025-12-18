import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Cart BLoC events.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Requests loading cart items.
final class CartLoadRequested extends CartEvent {
  const CartLoadRequested();
}

/// Requests adding a product to the cart.
final class CartItemAdded extends CartEvent {
  const CartItemAdded({required this.product, this.quantity = 1});
  final Product product;
  final int quantity;

  @override
  List<Object> get props => [product, quantity];
}

/// Requests removing a cart item.
final class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.productId);
  final int productId;

  @override
  List<Object> get props => [productId];
}

/// Requests updating a cart item quantity.
final class CartItemQuantityUpdated extends CartEvent {
  const CartItemQuantityUpdated({
    required this.productId,
    required this.quantity,
  });
  final int productId;
  final int quantity;

  @override
  List<Object> get props => [productId, quantity];
}

/// Requests clearing the cart.
final class CartCleared extends CartEvent {
  const CartCleared();
}
