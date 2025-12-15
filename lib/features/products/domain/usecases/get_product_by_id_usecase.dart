import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener un producto por ID.
class GetProductByIdUseCase {
  GetProductByIdUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, Product>> call(int id) async {
    return _repository.getProductById(id);
  }
}
