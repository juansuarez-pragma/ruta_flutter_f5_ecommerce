import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';

// Events
sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

final class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted();
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

  CheckoutBloc({required ClearCartUseCase clearCartUseCase})
    : _clearCartUseCase = clearCartUseCase,
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

      // Limpiar carrito
      await _clearCartUseCase();

      // Generar ID de orden simulado
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      emit(CheckoutSuccess(orderId));
    } catch (e) {
      emit(CheckoutError('Error al procesar el pedido: $e'));
    }
  }
}
