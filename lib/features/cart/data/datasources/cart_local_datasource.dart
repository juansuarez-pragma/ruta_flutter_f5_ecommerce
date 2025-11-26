import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/cart_item_model.dart';

/// Contrato para el datasource local del carrito.
abstract class CartLocalDataSource {
  /// Obtiene los items del carrito desde almacenamiento local.
  Future<List<CartItemModel>> getItems();

  /// Guarda los items del carrito en almacenamiento local.
  Future<void> saveItems(List<CartItemModel> items);

  /// Limpia el carrito del almacenamiento local.
  Future<void> clearItems();
}

/// Implementación del datasource local usando SharedPreferences.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences _sharedPreferences;

  CartLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<List<CartItemModel>> getItems() async {
    final jsonString = _sharedPreferences.getString(
      AppConstants.cartStorageKey,
    );
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return CartItemModel.decodeList(jsonString);
  }

  @override
  Future<void> saveItems(List<CartItemModel> items) async {
    final jsonString = CartItemModel.encodeList(items);
    await _sharedPreferences.setString(AppConstants.cartStorageKey, jsonString);
  }

  @override
  Future<void> clearItems() async {
    await _sharedPreferences.remove(AppConstants.cartStorageKey);
  }
}
