import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener todos los productos.
class GetProductsUseCase {
  final FakeStoreClient _client;

  GetProductsUseCase({required FakeStoreClient client}) : _client = client;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<Product>>> call() async {
    return _client.getProducts();
  }
}
