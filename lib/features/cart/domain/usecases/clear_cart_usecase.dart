import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for clearing the cart.
class ClearCartUseCase {
  ClearCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Executes the use case.
  Future<void> call() async {
    return _repository.clearCart();
  }
}
