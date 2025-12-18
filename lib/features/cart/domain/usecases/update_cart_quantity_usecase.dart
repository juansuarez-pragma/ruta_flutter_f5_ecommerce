import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for updating an item's quantity.
class UpdateCartQuantityUseCase {
  UpdateCartQuantityUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Executes the use case.
  Future<void> call(int productId, int quantity) async {
    return _repository.updateQuantity(productId, quantity);
  }
}
