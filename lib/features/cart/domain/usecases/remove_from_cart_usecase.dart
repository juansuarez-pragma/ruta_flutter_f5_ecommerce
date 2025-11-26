import '../repositories/cart_repository.dart';

/// Caso de uso para eliminar un item del carrito.
class RemoveFromCartUseCase {
  final CartRepository _repository;

  RemoveFromCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<void> call(int productId) async {
    return _repository.removeItem(productId);
  }
}
