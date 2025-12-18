import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Use case to fetch all categories.
class GetCategoriesUseCase {
  GetCategoriesUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<FakeStoreFailure, List<String>>> call() async {
    return _repository.getAllCategories();
  }
}
