import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener un producto por ID.
class GetProductByIdUseCase {
  final FakeStoreClient _client;

  GetProductByIdUseCase({required FakeStoreClient client}) : _client = client;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, Product>> call(int id) async {
    return _client.getProductById(id);
  }
}
