import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/core/config/config.dart';
import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/products/products.dart';
import 'package:ecommerce/features/categories/categories.dart';
import 'package:ecommerce/features/cart/cart.dart';
import 'package:ecommerce/features/checkout/checkout.dart';
import 'package:ecommerce/features/search/search.dart';
import 'package:ecommerce/features/orders/orders.dart';

/// Instancia global del contenedor de dependencias.
final sl = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación.
///
/// Debe ser llamado antes de runApp() en main.dart.
Future<void> initDependencies() async {
  // ============ External ============
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ============ Config (Fase 7 - Parametrización JSON) ============
  sl.registerLazySingleton<ConfigDataSource>(() => ConfigLocalDataSource());
  final configDataSource = sl<ConfigDataSource>();
  final appConfig = await configDataSource.loadConfig();
  sl.registerLazySingleton(() => appConfig);

  // ============ API Client (Fase 3) ============
  // La nueva API usa FakeStoreApi.createRepository() que retorna ProductRepository
  sl.registerLazySingleton<ProductRepository>(
    () => FakeStoreApi.createRepository(),
  );

  // ============ DataSources ============
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ============ Repositories ============
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: sl()),
  );

  // ============ UseCases - Products ============
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetProductsByCategoryUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: sl()));

  // ============ UseCases - Cart ============
  sl.registerLazySingleton(() => GetCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl()));

  // ============ UseCases - Orders ============
  sl.registerLazySingleton(() => GetOrdersUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOrderByIdUseCase(repository: sl()));

  // ============ BLoCs ============
  sl.registerFactory(
    () => HomeBloc(getProductsUseCase: sl(), getCategoriesUseCase: sl()),
  );

  sl.registerFactory(
    () => ProductsBloc(
      getProductsUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ProductDetailBloc(getProductByIdUseCase: sl()));

  sl.registerFactory(() => CategoriesBloc(getCategoriesUseCase: sl()));

  sl.registerFactory(
    () => CartBloc(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      updateQuantityUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SearchBloc(searchProductsUseCase: sl()));

  sl.registerFactory(
    () => CheckoutBloc(clearCartUseCase: sl(), saveOrderUseCase: sl()),
  );

  sl.registerFactory(
    () => OrderHistoryBloc(getOrdersUseCase: sl(), appConfig: sl()),
  );
}

/// Limpia las dependencias al cerrar la aplicación.
void disposeDependencies() {
  // ProductRepository no requiere dispose() ya que el cliente HTTP es interno
  // Si se necesita limpiar recursos, get_it lo maneja automáticamente
  sl.reset();
}
