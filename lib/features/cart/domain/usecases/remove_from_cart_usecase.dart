import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para eliminar un item del carrito.
class RemoveFromCartUseCase {
  RemoveFromCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Ejecuta el caso de uso.
  Future<void> call(int productId) async {
    return _repository.removeItem(productId);
  }
}
