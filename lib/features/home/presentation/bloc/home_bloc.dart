import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../categories/domain/usecases/get_categories_usecase.dart';
import '../../../products/domain/usecases/get_products_usecase.dart';

// Events
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested();
}

final class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

// States
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final List<String> categories;
  final List<Product> featuredProducts;

  const HomeLoaded({required this.categories, required this.featuredProducts});

  @override
  List<Object> get props => [categories, featuredProducts];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado del Home.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    // Cargar categorías
    final categoriesResult = await _getCategoriesUseCase();

    await categoriesResult.fold(
      (failure) async {
        emit(HomeError(failure.message));
      },
      (categories) async {
        // Cargar productos
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
