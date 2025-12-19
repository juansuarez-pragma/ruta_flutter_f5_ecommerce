import 'package:equatable/equatable.dart';

import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

// Events
sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

final class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted({required this.cartItems, required this.totalPrice});
  final List<CartItem> cartItems;
  final double totalPrice;

  @override
  List<Object> get props => [cartItems, totalPrice];
}

