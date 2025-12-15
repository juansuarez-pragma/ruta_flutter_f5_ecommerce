import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/features/orders/data/models/order_model.dart';

/// DataSource local para órdenes usando SharedPreferences.
abstract class OrderLocalDataSource {
  /// Obtiene todas las órdenes guardadas.
  Future<List<OrderModel>> getOrders();

  /// Guarda una orden.
  Future<void> saveOrder(OrderModel order);

  /// Obtiene una orden por ID.
  Future<OrderModel?> getOrderById(String id);

  /// Elimina una orden por ID.
  Future<void> deleteOrder(String id);
}

/// Implementación de OrderLocalDataSource.
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  OrderLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;
  static const String _ordersKey = 'orders_history';

  final SharedPreferences _sharedPreferences;

  @override
  Future<List<OrderModel>> getOrders() async {
    final jsonString = _sharedPreferences.getString(_ordersKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.insert(0, order); // Agregar al inicio (más reciente primero)

    final jsonList = orders.map((o) => o.toJson()).toList();
    await _sharedPreferences.setString(_ordersKey, json.encode(jsonList));
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    final orders = await getOrders();
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    final orders = await getOrders();
    orders.removeWhere((order) => order.id == id);

    final jsonList = orders.map((o) => o.toJson()).toList();
    await _sharedPreferences.setString(_ordersKey, json.encode(jsonList));
  }
}
