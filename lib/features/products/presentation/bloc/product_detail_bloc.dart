import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

export 'product_detail_event.dart';
export 'product_detail_state.dart';

/// BLoC that manages product detail state.
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
