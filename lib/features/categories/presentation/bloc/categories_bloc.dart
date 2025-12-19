import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/categories/domain/usecases/get_categories_usecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

export 'categories_event.dart';
export 'categories_state.dart';

/// BLoC that manages categories state.
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase,
      super(const CategoriesInitial()) {
    on<CategoriesLoadRequested>(_onLoadRequested);
  }
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadRequested(
    CategoriesLoadRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());

    final result = await _getCategoriesUseCase();

    emit(
      result.fold(
        (failure) => CategoriesError(failure.message),
        (categories) => CategoriesLoaded(categories),
      ),
    );
  }
}
