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
  final int productId;

  const ProductDetailLoadRequested(this.productId);

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
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

final class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado del detalle de producto.
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUseCase _getProductByIdUseCase;

  ProductDetailBloc({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase,
      super(const ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onLoadRequested);
  }

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
