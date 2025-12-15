import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para agregar un item al carrito.
class AddToCartUseCase {
  AddToCartUseCase({required CartRepository repository})
    : _repository = repository;
  final CartRepository _repository;

  /// Ejecuta el caso de uso.
  Future<void> call(CartItem item) async {
    return _repository.addItem(item);
  }
}
