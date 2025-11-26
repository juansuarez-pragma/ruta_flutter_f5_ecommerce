import '../repositories/cart_repository.dart';

/// Caso de uso para limpiar el carrito.
class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<void> call() async {
    return _repository.clearCart();
  }
}
