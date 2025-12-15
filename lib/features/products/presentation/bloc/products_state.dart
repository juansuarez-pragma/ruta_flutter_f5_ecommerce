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
  const ProductsLoaded({required this.products, this.category});
  final List<Product> products;
  final String? category;

  @override
  List<Object?> get props => [products, category];
}

/// Estado de error.
final class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
