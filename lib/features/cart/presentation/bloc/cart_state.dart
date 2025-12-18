import 'package:equatable/equatable.dart';

import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// Cart BLoC states.
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state.
final class CartLoading extends CartState {
  const CartLoading();
}

/// Loaded state.
final class CartLoaded extends CartState {
  const CartLoaded({required this.items});
  final List<CartItem> items;

  /// Total number of items in the cart.
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Total cart price.
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Whether the cart is empty.
  bool get isEmpty => items.isEmpty;

  @override
  List<Object> get props => [items];
}

/// Error state.
final class CartError extends CartState {
  const CartError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
