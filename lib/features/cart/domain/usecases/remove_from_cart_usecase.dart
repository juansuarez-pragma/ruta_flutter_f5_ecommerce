import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for removing an item from the cart.
class RemoveFromCartUseCase {
  RemoveFromCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Executes the use case.
  Future<void> call(int productId) async {
    return _repository.removeItem(productId);
  }
}
