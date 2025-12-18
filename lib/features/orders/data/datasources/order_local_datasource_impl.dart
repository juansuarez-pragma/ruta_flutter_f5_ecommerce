import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';
import 'package:ecommerce/features/orders/data/datasources/order_local_datasource.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';

/// [OrderLocalDataSource] implementation.
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

    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e, st) {
      final exception = ParseException(
        message: 'Failed to decode orders list',
        failedValue: jsonString.length > 200
            ? '${jsonString.substring(0, 200)}...'
            : jsonString,
        originalException: e,
      );

      ErrorLogger().logAppException(
        exception,
        context: {'operation': 'getOrders'},
        stackTrace: st,
      );

      throw exception;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Unexpected error while loading orders',
        failedValue: jsonString.length > 200
            ? '${jsonString.substring(0, 200)}...'
            : jsonString,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
        exception,
        context: {'operation': 'getOrders'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    final orders = await getOrders();
    orders.insert(0, order);

    final jsonList = orders.map((o) => o.toJson()).toList();
    await _sharedPreferences.setString(_ordersKey, json.encode(jsonList));
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    try {
      final orders = await getOrders();
      final order = orders.firstWhereOrNull((order) => order.id == id);

      if (order == null) {
        ErrorLogger().logInfo(
          'Order not found: $id',
          context: {'operation': 'getOrderById'},
        );
      }

      return order;
    } catch (e, st) {
      final exception = UnknownException(
        message: 'Unexpected error while getting order by id',
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
        exception,
        context: {'operation': 'getOrderById', 'orderId': id},
        stackTrace: st,
      );

      throw exception;
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
