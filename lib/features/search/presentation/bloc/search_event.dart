import 'package:equatable/equatable.dart';

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

