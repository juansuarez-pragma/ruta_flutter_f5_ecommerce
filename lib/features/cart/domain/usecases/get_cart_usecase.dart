import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

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
