import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:ecommerce/features/cart/data/models/cart_item_model.dart';

/// Implementación del datasource local usando SharedPreferences.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<List<CartItemModel>> getItems() async {
    final jsonString = _sharedPreferences.getString(AppConstants.cartStorageKey);
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

