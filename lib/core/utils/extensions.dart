import 'package:flutter/material.dart';

/// Utility extensions for BuildContext.
extension ContextExtensions on BuildContext {
  /// Gets the MediaQuery for this context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width.
  double get screenWidth => mediaQuery.size.width;

  /// Screen height.
  double get screenHeight => mediaQuery.size.height;

  /// Whether the device is a tablet (width > 600).
  bool get isTablet => screenWidth > 600;

  /// Whether the device is in landscape orientation.
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Shows a SnackBar with the provided message.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}

/// Utility extensions for String.
extension StringExtensions on String {
  /// Uppercases the first character.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Uppercases the first character of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}

/// Utility extensions for double (prices).
extension PriceExtensions on double {
  /// Formats a price with a dollar sign.
  String get toCurrency => '\$${toStringAsFixed(2)}';
}
