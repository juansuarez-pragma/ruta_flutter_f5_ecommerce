import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/config/models/order_history_config.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';

// States
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

