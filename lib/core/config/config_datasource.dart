import 'package:ecommerce/core/config/app_config.dart';

/// DataSource para leer la configuración desde assets.
abstract class ConfigDataSource {
  /// Carga la configuración de la aplicación desde el JSON.
  Future<AppConfig> loadConfig();
}
