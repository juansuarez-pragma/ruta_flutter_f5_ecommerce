import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Caso de uso para obtener el historial de órdenes.
class GetOrdersUseCase {
  GetOrdersUseCase({required OrderRepository repository})
    : _repository = repository;
  final OrderRepository _repository;

  /// Ejecuta el caso de uso.
  Future<List<Order>> call() async {
    final orders = await _repository.getOrders();
    // Ordenar por fecha descendente (más recientes primero)
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }
}
