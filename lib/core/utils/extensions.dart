import 'package:flutter/material.dart';

/// Extensiones de utilidad para BuildContext.
extension ContextExtensions on BuildContext {
  /// Obtiene el MediaQuery del contexto.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Obtiene el ancho de pantalla.
  double get screenWidth => mediaQuery.size.width;

  /// Obtiene el alto de pantalla.
  double get screenHeight => mediaQuery.size.height;

  /// Indica si el dispositivo es una tablet (ancho > 600).
  bool get isTablet => screenWidth > 600;

  /// Indica si el dispositivo está en orientación landscape.
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Muestra un SnackBar con el mensaje proporcionado.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}

/// Extensiones de utilidad para String.
extension StringExtensions on String {
  /// Capitaliza la primera letra del string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitaliza cada palabra del string.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}

/// Extensiones de utilidad para double (precios).
extension PriceExtensions on double {
  /// Formatea el precio con símbolo de dólar.
  String get toCurrency => '\$${toStringAsFixed(2)}';
}
