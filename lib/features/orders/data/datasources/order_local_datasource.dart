import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';
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

    try {
      // Decodificar JSON de forma segura
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e, st) {
      // Error de formato JSON
      final exception = ParseException(
        message: 'Error al decodificar lista de órdenes',
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
      // Otra excepción
      final exception = ParseException(
        message: 'Error inesperado al cargar órdenes',
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
    orders.insert(0, order); // Agregar al inicio (más reciente primero)

    final jsonList = orders.map((o) => o.toJson()).toList();
    await _sharedPreferences.setString(_ordersKey, json.encode(jsonList));
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    try {
      final orders = await getOrders();

      // Usar firstWhereOrNull en lugar de firstWhere con catch
      // Esto es más explícito: "no encontrado" retorna null sin error
      final order = orders.firstWhereOrNull((order) => order.id == id);

      if (order == null) {
        // Logging para auditoría: registro que se buscó una orden que no existe
        ErrorLogger().logInfo(
          'Orden no encontrada: $id',
          context: {'operation': 'getOrderById'},
        );
      }

      return order;
    } catch (e, st) {
      // Si ocurre excepción inesperada (ej: getOrders falla), loguear y relanzar
      final exception = UnknownException(
        message: 'Error inesperado al obtener orden por ID',
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
        exception,
        context: {
          'operation': 'getOrderById',
          'orderId': id,
        },
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
