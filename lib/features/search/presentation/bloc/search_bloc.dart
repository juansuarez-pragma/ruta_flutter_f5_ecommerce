import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/search/domain/usecases/search_products_usecase.dart';

// Events
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

// States
sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchLoaded extends SearchState {
  const SearchLoaded({required this.products, required this.query});
  final List<Product> products;
  final String query;

  @override
  List<Object> get props => [products, query];
}

final class SearchError extends SearchState {
  const SearchError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado de búsqueda.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchProductsUseCase searchProductsUseCase})
    : _searchProductsUseCase = searchProductsUseCase,
      super(const SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchCleared>(_onCleared);
  }
  final SearchProductsUseCase _searchProductsUseCase;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    final result = await _searchProductsUseCase(event.query);

    emit(
      result.fold(
        (failure) => SearchError(failure.message),
        (products) => SearchLoaded(products: products, query: event.query),
      ),
    );
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }
}
