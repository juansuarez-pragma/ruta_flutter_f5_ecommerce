import 'package:equatable/equatable.dart';

/// Products BLoC events.
sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Requests loading products.
final class ProductsLoadRequested extends ProductsEvent {
  const ProductsLoadRequested({this.category});

  /// Optional category filter.
  final String? category;

  @override
  List<Object?> get props => [category];
}

/// Requests refreshing products.
final class ProductsRefreshRequested extends ProductsEvent {
  const ProductsRefreshRequested();
}
