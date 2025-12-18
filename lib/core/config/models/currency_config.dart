import 'package:equatable/equatable.dart';

/// Configuración de moneda.
class CurrencyConfig extends Equatable {
  const CurrencyConfig({
    required this.symbol,
    required this.decimalDigits,
    required this.locale,
  });

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) {
    return CurrencyConfig(
      symbol: json['symbol'] as String,
      decimalDigits: json['decimalDigits'] as int,
      locale: json['locale'] as String,
    );
  }

  final String symbol;
  final int decimalDigits;
  final String locale;

  @override
  List<Object?> get props => [symbol, decimalDigits, locale];
}

