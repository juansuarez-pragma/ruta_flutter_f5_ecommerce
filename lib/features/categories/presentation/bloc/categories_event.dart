import 'package:equatable/equatable.dart';

// Events
sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

final class CategoriesLoadRequested extends CategoriesEvent {
  const CategoriesLoadRequested();
}

