import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/core/constants/app_constants.dart';

/// Datos de la pantalla home.
class HomeData {
  final List<String> categories;
  final List<Product> featuredProducts;

  const HomeData({required this.categories, required this.featuredProducts});
}

/// Caso de uso para obtener los datos del home.
class GetHomeDataUseCase {
  final ProductRepository _repository;

  GetHomeDataUseCase({required ProductRepository repository})
      : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, HomeData>> call() async {
    // Obtener categorías
    final categoriesResult = await _repository.getAllCategories();

    return categoriesResult.fold((failure) => Left(failure), (
      categories,
    ) async {
      // Obtener productos
      final productsResult = await _repository.getAllProducts();

      return productsResult.fold((failure) => Left(failure), (products) {
        // Limitar a productos destacados
        final featured = products
            .take(AppConstants.featuredProductsLimit)
            .toList();

        return Right(
          HomeData(categories: categories, featuredProducts: featured),
        );
      });
    });
  }
}
