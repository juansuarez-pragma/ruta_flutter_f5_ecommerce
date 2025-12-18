import 'dart:convert';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/core/config/asset_string_loader.dart';
import 'package:ecommerce/core/config/config_datasource.dart';

/// Implementation that reads configuration from a JSON asset.
class ConfigLocalDataSource implements ConfigDataSource {
  ConfigLocalDataSource({required AssetStringLoader assetLoader})
    : _assetLoader = assetLoader;

  static const String _configPath = 'assets/config/app_config.json';

  AppConfig? _cachedConfig;
  final AssetStringLoader _assetLoader;

  @override
  Future<AppConfig> loadConfig() async {
    if (_cachedConfig != null) {
      return _cachedConfig!;
    }

    final jsonString = await _assetLoader.loadString(_configPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _cachedConfig = AppConfig.fromJson(jsonMap);

    return _cachedConfig!;
  }
}
