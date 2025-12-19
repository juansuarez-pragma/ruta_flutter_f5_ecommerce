import 'package:equatable/equatable.dart';

// States
sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

final class CheckoutProcessing extends CheckoutState {
  const CheckoutProcessing();
}

final class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess(this.orderId);
  final String orderId;

  @override
  List<Object> get props => [orderId];
}

final class CheckoutError extends CheckoutState {
  const CheckoutError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

