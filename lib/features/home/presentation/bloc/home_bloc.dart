import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

/// BLoC that manages Home state.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    // Load categories
    final categoriesResult = await _getCategoriesUseCase();

    await categoriesResult.fold(
      (failure) async {
        emit(HomeError(failure.message));
      },
      (categories) async {
        // Load products
        final productsResult = await _getProductsUseCase();

        productsResult.fold(
          (failure) {
            emit(HomeError(failure.message));
          },
          (products) {
            final featured = products
                .take(AppConstants.featuredProductsLimit)
                .toList();
            emit(
              HomeLoaded(categories: categories, featuredProducts: featured),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(const HomeLoadRequested());
  }
}
