import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutSubmitted({required this.cartItems, required this.totalPrice});

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
  final String orderId;

  const CheckoutSuccess(this.orderId);

  @override
  List<Object> get props => [orderId];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado del checkout.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ClearCartUseCase _clearCartUseCase;
  final SaveOrderUseCase _saveOrderUseCase;

  CheckoutBloc({
    required ClearCartUseCase clearCartUseCase,
    required SaveOrderUseCase saveOrderUseCase,
  }) : _clearCartUseCase = clearCartUseCase,
       _saveOrderUseCase = saveOrderUseCase,
       super(const CheckoutInitial()) {
    on<CheckoutSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutProcessing());

    try {
      // Simular procesamiento
      await Future.delayed(const Duration(seconds: 2));

      // Generar ID de orden
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      // Crear y guardar la orden
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
        createdAt: DateTime.now(),
        status: OrderStatus.completed,
      );

      await _saveOrderUseCase(order);

      // Limpiar carrito
      await _clearCartUseCase();

      emit(CheckoutSuccess(orderId));
    } catch (e) {
      emit(CheckoutError('Error al procesar el pedido: $e'));
    }
  }
}
