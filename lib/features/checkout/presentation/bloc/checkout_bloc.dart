import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/utils/clock.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/usecases/save_order_usecase.dart';

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

/// BLoC that manages checkout state.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({
    required ClearCartUseCase clearCartUseCase,
    required SaveOrderUseCase saveOrderUseCase,
    required Clock clock,
  }) : _clearCartUseCase = clearCartUseCase,
       _saveOrderUseCase = saveOrderUseCase,
       _clock = clock,
       super(const CheckoutInitial()) {
    on<CheckoutSubmitted>(_onSubmitted);
  }
  final ClearCartUseCase _clearCartUseCase;
  final SaveOrderUseCase _saveOrderUseCase;
  final Clock _clock;

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutProcessing());

    try {
      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      final now = _clock.now();

      // Generate order id
      final orderId = 'ORD-${now.millisecondsSinceEpoch}';

      // Create and save the order
      final order = Order(
        id: orderId,
        items: event.cartItems
            .map(
              (cartItem) => OrderItem(
                productId: cartItem.product.id,
                title: cartItem.product.title,
                price: cartItem.product.price,
                quantity: cartItem.quantity,
                imageUrl: cartItem.product.image,
              ),
            )
            .toList(),
        total: event.totalPrice,
        createdAt: now,
      );

      await _saveOrderUseCase(order);

      // Clear cart
      await _clearCartUseCase();

      emit(CheckoutSuccess(orderId));
    } catch (e) {
      emit(CheckoutError('Error processing the order: $e'));
    }
  }
}
