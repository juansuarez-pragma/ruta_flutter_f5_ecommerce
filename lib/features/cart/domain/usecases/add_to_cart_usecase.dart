import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for adding an item to the cart.
class AddToCartUseCase {
  AddToCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Executes the use case.
  Future<void> call(CartItem item) async {
    return _repository.addItem(item);
  }
}
