import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Estados del BLoC de productos.
sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
final class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

/// Estado de carga.
final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

/// Estado con productos cargados.
final class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String? category;

  const ProductsLoaded({required this.products, this.category});

  @override
  List<Object?> get props => [products, category];
}

/// Estado de error.
final class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
