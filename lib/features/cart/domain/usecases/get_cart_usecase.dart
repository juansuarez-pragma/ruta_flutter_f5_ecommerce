import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Caso de uso para obtener los items del carrito.
class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<List<CartItem>> call() async {
    return _repository.getCartItems();
  }
}
