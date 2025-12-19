import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/features/orders/domain/usecases/get_orders_usecase.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

export 'order_history_event.dart';
export 'order_history_state.dart';

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
      emit(OrderHistoryError('Failed to load order history: $e'));
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
      emit(OrderHistoryError('Failed to refresh order history: $e'));
    }
  }
}
