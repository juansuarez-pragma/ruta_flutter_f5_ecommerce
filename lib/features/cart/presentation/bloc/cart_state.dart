import 'package:equatable/equatable.dart';

import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// Estados del BLoC del carrito.
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial del carrito.
final class CartInitial extends CartState {
  const CartInitial();
}

/// Estado de carga del carrito.
final class CartLoading extends CartState {
  const CartLoading();
}

/// Estado con el carrito cargado.
final class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  /// Número total de items en el carrito.
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Precio total del carrito.
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Indica si el carrito está vacío.
  bool get isEmpty => items.isEmpty;

  @override
  List<Object> get props => [items];
}

/// Estado de error del carrito.
final class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
