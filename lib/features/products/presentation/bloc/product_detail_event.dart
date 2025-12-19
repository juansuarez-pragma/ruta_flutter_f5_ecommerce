import 'package:equatable/equatable.dart';

// Events
sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

final class ProductDetailLoadRequested extends ProductDetailEvent {
  const ProductDetailLoadRequested(this.productId);
  final int productId;

  @override
  List<Object> get props => [productId];
}

