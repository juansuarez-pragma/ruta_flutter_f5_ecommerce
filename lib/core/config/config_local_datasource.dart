import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/core/config/config_datasource.dart';

/// Implementation that reads configuration from a JSON asset.
class ConfigLocalDataSource implements ConfigDataSource {
  static const String _configPath = 'assets/config/app_config.json';

  AppConfig? _cachedConfig;

  @override
  Future<AppConfig> loadConfig() async {
    if (_cachedConfig != null) {
      return _cachedConfig!;
    }

    final jsonString = await rootBundle.loadString(_configPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _cachedConfig = AppConfig.fromJson(jsonMap);

    return _cachedConfig!;
  }
}
