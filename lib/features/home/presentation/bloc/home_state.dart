import 'package:equatable/equatable.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

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
  const HomeLoaded({required this.categories, required this.featuredProducts});
  final List<String> categories;
  final List<Product> featuredProducts;

  @override
  List<Object> get props => [categories, featuredProducts];
}

final class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

