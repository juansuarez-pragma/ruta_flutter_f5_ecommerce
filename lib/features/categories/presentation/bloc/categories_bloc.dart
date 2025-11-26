import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories_usecase.dart';

// Events
sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

final class CategoriesLoadRequested extends CategoriesEvent {
  const CategoriesLoadRequested();
}

// States
sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

final class CategoriesLoaded extends CategoriesState {
  final List<String> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

final class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

/// BLoC para gestionar el estado de categorías.
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase,
      super(const CategoriesInitial()) {
    on<CategoriesLoadRequested>(_onLoadRequested);
  }

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
