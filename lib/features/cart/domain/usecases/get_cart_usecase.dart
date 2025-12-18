import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for retrieving cart items.
class GetCartUseCase {
  GetCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Executes the use case.
  Future<List<CartItem>> call() async {
    return _repository.getCartItems();
  }
}
