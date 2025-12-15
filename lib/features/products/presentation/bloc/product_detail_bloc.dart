import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/products/domain/usecases/get_product_by_id_usecase.dart';

// Events
sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

final class ProductDetailLoadRequested extends ProductDetailEvent {
  const ProductDetailLoadRequested(this.productId);
  final int productId;

  @override
  List<Object> get props => [productId];
}

// States
sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

final class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

final class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.product);
  final Product product;

  @override
  List<Object> get props => [product];
}

final class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado del detalle de producto.
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase,
      super(const ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onLoadRequested);
  }
  final GetProductByIdUseCase _getProductByIdUseCase;

  Future<void> _onLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());

    final result = await _getProductByIdUseCase(event.productId);

    emit(
      result.fold(
        (failure) => ProductDetailError(failure.message),
        (product) => ProductDetailLoaded(product),
      ),
    );
  }
}
