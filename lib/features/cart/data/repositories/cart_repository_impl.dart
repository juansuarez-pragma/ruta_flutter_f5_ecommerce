import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:ecommerce/features/cart/data/models/cart_item_model.dart';

/// Implementación del repositorio del carrito.
///
/// Gestiona el carrito usando el datasource local.
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl({required CartLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<CartItem>> getCartItems() async {
    final models = await _localDataSource.getItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addItem(CartItem item) async {
    final models = await _localDataSource.getItems();
    final existingIndex = models.indexWhere(
      (model) => model.productId == item.product.id,
    );

    if (existingIndex >= 0) {
      // Si existe, incrementa la cantidad
      final existing = models[existingIndex];
      models[existingIndex] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    } else {
      // Si no existe, agrega el nuevo item
      models.add(CartItemModel.fromEntity(item));
    }

    await _localDataSource.saveItems(models);
  }

  @override
  Future<void> removeItem(int productId) async {
    final models = await _localDataSource.getItems();
    models.removeWhere((model) => model.productId == productId);
    await _localDataSource.saveItems(models);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final models = await _localDataSource.getItems();
    final index = models.indexWhere((model) => model.productId == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        models.removeAt(index);
      } else {
        models[index] = models[index].copyWith(quantity: quantity);
      }
      await _localDataSource.saveItems(models);
    }
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clearItems();
  }
}
