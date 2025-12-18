import 'package:ecommerce/core/config/app_config.dart';

/// DataSource for loading configuration from assets.
abstract class ConfigDataSource {
  /// Loads the application configuration from JSON.
  Future<AppConfig> loadConfig();
}
