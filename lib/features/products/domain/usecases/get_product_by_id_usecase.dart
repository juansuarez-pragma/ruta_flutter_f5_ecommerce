import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener un producto por ID.
class GetProductByIdUseCase {
  final ProductRepository _repository;

  GetProductByIdUseCase({required ProductRepository repository})
      : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, Product>> call(int id) async {
    return _repository.getProductById(id);
  }
}
