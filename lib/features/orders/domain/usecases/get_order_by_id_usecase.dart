import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Caso de uso para obtener una orden por ID.
class GetOrderByIdUseCase {
  GetOrderByIdUseCase({required OrderRepository repository})
    : _repository = repository;
  final OrderRepository _repository;

  /// Ejecuta el caso de uso.
  Future<Order?> call(String orderId) async {
    return _repository.getOrderById(orderId);
  }
}
