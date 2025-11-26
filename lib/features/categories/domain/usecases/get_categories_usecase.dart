import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener todas las categorías.
class GetCategoriesUseCase {
  final FakeStoreClient _client;

  GetCategoriesUseCase({required FakeStoreClient client}) : _client = client;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<String>>> call() async {
    return _client.getCategories();
  }
}
