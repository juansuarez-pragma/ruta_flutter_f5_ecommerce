import 'package:equatable/equatable.dart';

// Events
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

