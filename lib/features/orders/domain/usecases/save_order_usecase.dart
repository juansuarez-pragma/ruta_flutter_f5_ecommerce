import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Caso de uso para guardar una nueva orden.
class SaveOrderUseCase {
  final OrderRepository _repository;

  SaveOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<void> call(Order order) async {
    await _repository.saveOrder(order);
  }
}
