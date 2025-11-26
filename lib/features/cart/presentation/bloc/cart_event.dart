import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Eventos del BLoC del carrito.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar los items del carrito.
final class CartLoadRequested extends CartEvent {
  const CartLoadRequested();
}

/// Solicita agregar un producto al carrito.
final class CartItemAdded extends CartEvent {
  final Product product;
  final int quantity;

  const CartItemAdded({required this.product, this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

/// Solicita eliminar un item del carrito.
final class CartItemRemoved extends CartEvent {
  final int productId;

  const CartItemRemoved(this.productId);

  @override
  List<Object> get props => [productId];
}

/// Solicita actualizar la cantidad de un item.
final class CartItemQuantityUpdated extends CartEvent {
  final int productId;
  final int quantity;

  const CartItemQuantityUpdated({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}

/// Solicita limpiar el carrito.
final class CartCleared extends CartEvent {
  const CartCleared();
}
