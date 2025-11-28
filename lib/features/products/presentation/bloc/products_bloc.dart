import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';

/// BLoC para gestionar el estado de productos.
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  ProductsBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(const ProductsInitial()) {
    on<ProductsLoadRequested>(_onLoadRequested);
    on<ProductsRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final result = event.category != null
        ? await _getProductsByCategoryUseCase(event.category!)
        : await _getProductsUseCase();

    emit(
      result.fold(
        (failure) => ProductsError(failure.message),
        (products) =>
            ProductsLoaded(products: products, category: event.category),
      ),
    );
  }

  Future<void> _onRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      add(ProductsLoadRequested(category: currentState.category));
    }
  }
}
