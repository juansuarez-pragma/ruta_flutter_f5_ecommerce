import 'package:equatable/equatable.dart';

/// Eventos del BLoC de productos.
sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar productos.
final class ProductsLoadRequested extends ProductsEvent {
  const ProductsLoadRequested({this.category});

  /// Categoría opcional para filtrar.
  final String? category;

  @override
  List<Object?> get props => [category];
}

/// Solicita refrescar productos.
final class ProductsRefreshRequested extends ProductsEvent {
  const ProductsRefreshRequested();
}
