import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ecommerce/core/config/config.dart';
import 'package:ecommerce/core/config/asset_string_loader.dart';
import 'package:ecommerce/core/config/config_local_datasource.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';
import 'package:ecommerce/core/storage/flutter_secure_storage_store.dart';
import 'package:ecommerce/core/storage/secure_key_value_store.dart';
import 'package:ecommerce/core/utils/clock.dart';
import 'package:ecommerce/core/utils/id_generator.dart';
import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/products/products.dart';
import 'package:ecommerce/features/categories/categories.dart';
import 'package:ecommerce/features/cart/cart.dart';
import 'package:ecommerce/features/cart/data/datasources/cart_local_datasource_impl.dart';
import 'package:ecommerce/features/checkout/checkout.dart';
import 'package:ecommerce/features/search/search.dart';
import 'package:ecommerce/features/orders/orders.dart';
import 'package:ecommerce/features/orders/data/datasources/order_local_datasource_impl.dart';
import 'package:ecommerce/features/auth/auth.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:ecommerce/features/auth/data/security/password_hasher.dart';
import 'package:ecommerce/features/support/support.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource_impl.dart';

/// Global instance of the dependency injection container.
final sl = GetIt.instance;

/// Initializes all app dependencies.
///
/// Must be called before runApp() in main.dart.
Future<void> initDependencies() async {
  // ============ Core utilities ============
  sl.registerLazySingleton<Clock>(() => const SystemClock());
  sl.registerLazySingleton<IdGenerator>(() => const UuidV4Generator());

  // ============ Error Handling (Phase 8 - Exceptions) ============
  sl.registerLazySingleton<AppLogger>(() => ErrorLogger(clock: sl()));

  // ============ External ============
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<SecureKeyValueStore>(
    () => FlutterSecureStorageStore(storage: sl()),
  );

  // ============ Assets ============
  sl.registerLazySingleton<AssetStringLoader>(
    () => const RootBundleAssetStringLoader(),
  );

  // ============ Config (Phase 7 - JSON configuration) ============
  sl.registerLazySingleton<ConfigDataSource>(
    () => ConfigLocalDataSource(assetLoader: sl()),
  );
  final configDataSource = sl<ConfigDataSource>();
  final appConfig = await configDataSource.loadConfig();
  sl.registerLazySingleton(() => appConfig);

  // ============ API Client (Phase 3) ============
  // The API uses FakeStoreApi.createRepository(), which returns ProductRepository.
  sl.registerLazySingleton<ProductRepository>(
    () => FakeStoreApi.createRepository(),
  );

  // ============ DataSources ============
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(sharedPreferences: sl(), logger: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      legacySharedPreferences: sl(),
      secureStore: sl(),
      passwordHasher: sl(),
      tokenGenerator: sl(),
      logger: sl(),
    ),
  );
  sl.registerLazySingleton<SupportLocalDataSource>(
    () => SupportLocalDataSourceImpl(sharedPreferences: sl(), logger: sl()),
  );

  // ============ Security ============
  sl.registerLazySingleton<PasswordHasher>(() => Pbkdf2PasswordHasher());

  // ============ Repositories ============
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(
      localDataSource: sl(),
      idGenerator: sl(),
      clock: sl(),
    ),
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

  // ============ UseCases - Auth ============
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));

  // ============ UseCases - Support ============
  sl.registerLazySingleton(() => GetFAQsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendContactMessageUseCase(repository: sl()));

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
    () => CheckoutBloc(
      clearCartUseCase: sl(),
      saveOrderUseCase: sl(),
      clock: sl(),
    ),
  );

  sl.registerFactory(
    () => OrderHistoryBloc(getOrdersUseCase: sl(), appConfig: sl()),
  );

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => SupportBloc(
      getFAQsUseCase: sl(),
      sendContactMessageUseCase: sl(),
      repository: sl(),
    ),
  );
}

/// Clears dependencies when closing the app.
