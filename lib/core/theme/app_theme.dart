import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

/// Wrapper for the Design System theme.
///
/// Provides centralized access to the light and dark themes of the Fake Store
/// design system.
class AppTheme {
  AppTheme._();

  /// Returns the light theme.
  static ThemeData get lightTheme => FakeStoreTheme.light();

  /// Returns the dark theme.
  static ThemeData get darkTheme => FakeStoreTheme.dark();

  /// Returns theme tokens from the context.
  static DSThemeData tokens(BuildContext context) => FakeStoreTheme.of(context);
}
