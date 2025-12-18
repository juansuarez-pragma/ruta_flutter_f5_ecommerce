import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/config/models/currency_config.dart';

/// Configuración general de la aplicación.
class SettingsConfig extends Equatable {
  const SettingsConfig({
    required this.maxOrdersToShow,
    required this.dateFormat,
    required this.currency,
  });

  factory SettingsConfig.fromJson(Map<String, dynamic> json) {
    return SettingsConfig(
      maxOrdersToShow: json['maxOrdersToShow'] as int,
      dateFormat: json['dateFormat'] as String,
      currency: CurrencyConfig.fromJson(
        json['currency'] as Map<String, dynamic>,
      ),
    );
  }

  final int maxOrdersToShow;
  final String dateFormat;
  final CurrencyConfig currency;

  @override
  List<Object?> get props => [maxOrdersToShow, dateFormat, currency];
}

