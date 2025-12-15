import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para limpiar el carrito.
class ClearCartUseCase {
  ClearCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Ejecuta el caso de uso.
  Future<void> call() async {
    return _repository.clearCart();
  }
}
