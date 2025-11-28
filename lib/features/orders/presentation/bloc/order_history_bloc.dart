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

/// Evento para cargar el historial de órdenes.
final class OrderHistoryLoadRequested extends OrderHistoryEvent {
  const OrderHistoryLoadRequested();
}

/// Evento para refrescar el historial.
final class OrderHistoryRefreshRequested extends OrderHistoryEvent {
  const OrderHistoryRefreshRequested();
}

// ============ States ============

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
final class OrderHistoryInitial extends OrderHistoryState {
  const OrderHistoryInitial();
}

/// Estado de carga.
final class OrderHistoryLoading extends OrderHistoryState {
  const OrderHistoryLoading();
}

/// Estado cargado con órdenes.
final class OrderHistoryLoaded extends OrderHistoryState {
  final List<Order> orders;
  final OrderHistoryConfig config;

  const OrderHistoryLoaded({required this.orders, required this.config});

  bool get isEmpty => orders.isEmpty;

  @override
  List<Object?> get props => [orders, config];
}

/// Estado de error.
final class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============ BLoC ============

/// BLoC para gestionar el historial de órdenes.
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final AppConfig _appConfig;

  OrderHistoryBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required AppConfig appConfig,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _appConfig = appConfig,
       super(const OrderHistoryInitial()) {
    on<OrderHistoryLoadRequested>(_onLoadRequested);
    on<OrderHistoryRefreshRequested>(_onRefreshRequested);
  }

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
