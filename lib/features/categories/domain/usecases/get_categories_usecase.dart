import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener todas las categorías.
class GetCategoriesUseCase {
  GetCategoriesUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<String>>> call() async {
    return _repository.getAllCategories();
  }
}
