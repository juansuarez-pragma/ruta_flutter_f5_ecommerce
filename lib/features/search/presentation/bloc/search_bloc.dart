import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/search/domain/usecases/search_products_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

export 'search_event.dart';
export 'search_state.dart';

/// BLoC that manages search state.
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
