import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para actualizar la cantidad de un item.
class UpdateCartQuantityUseCase {
  UpdateCartQuantityUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Ejecuta el caso de uso.
  Future<void> call(int productId, int quantity) async {
    return _repository.updateQuantity(productId, quantity);
  }
}
