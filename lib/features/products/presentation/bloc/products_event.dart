import 'package:equatable/equatable.dart';

/// Eventos del BLoC de productos.
sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar productos.
final class ProductsLoadRequested extends ProductsEvent {
  /// Categoría opcional para filtrar.
  final String? category;

  const ProductsLoadRequested({this.category});

  @override
  List<Object?> get props => [category];
}

/// Solicita refrescar productos.
final class ProductsRefreshRequested extends ProductsEvent {
  const ProductsRefreshRequested();
}
