import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener todos los productos.
class GetProductsUseCase {
  GetProductsUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<Product>>> call() async {
    return _repository.getAllProducts();
  }
}
