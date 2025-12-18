import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/usecases/get_orders_usecase.dart';

// ============ Events ============

sealed class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the order history.
final class OrderHistoryLoadRequested extends OrderHistoryEvent {
  const OrderHistoryLoadRequested();
}

/// Event to refresh the order history.
final class OrderHistoryRefreshRequested extends OrderHistoryEvent {
  const OrderHistoryRefreshRequested();
}

// ============ States ============

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class OrderHistoryInitial extends OrderHistoryState {
  const OrderHistoryInitial();
}

/// Loading state.
final class OrderHistoryLoading extends OrderHistoryState {
  const OrderHistoryLoading();
}

/// Loaded state with orders.
final class OrderHistoryLoaded extends OrderHistoryState {
  const OrderHistoryLoaded({required this.orders, required this.config});
  final List<Order> orders;
  final OrderHistoryConfig config;

  bool get isEmpty => orders.isEmpty;

  @override
  List<Object?> get props => [orders, config];
}

/// Error state.
final class OrderHistoryError extends OrderHistoryState {
  const OrderHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// ============ BLoC ============

/// BLoC that manages order history.
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required AppConfig appConfig,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _appConfig = appConfig,
       super(const OrderHistoryInitial()) {
    on<OrderHistoryLoadRequested>(_onLoadRequested);
    on<OrderHistoryRefreshRequested>(_onRefreshRequested);
  }
  final GetOrdersUseCase _getOrdersUseCase;
  final AppConfig _appConfig;

  Future<void> _onLoadRequested(
    OrderHistoryLoadRequested event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(const OrderHistoryLoading());

    try {
      final orders = await _getOrdersUseCase();
      emit(OrderHistoryLoaded(orders: orders, config: _appConfig.orderHistory));
    } catch (e) {
      emit(OrderHistoryError('Error al cargar el historial: $e'));
    }
  }

  Future<void> _onRefreshRequested(
    OrderHistoryRefreshRequested event,
    Emitter<OrderHistoryState> emit,
  ) async {
    try {
      final orders = await _getOrdersUseCase();
      emit(OrderHistoryLoaded(orders: orders, config: _appConfig.orderHistory));
    } catch (e) {
      emit(OrderHistoryError('Error al refrescar: $e'));
    }
  }
}
