import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

/// Wrapper para el tema del Design System.
///
/// Proporciona acceso centralizado a los temas claro y oscuro
/// del sistema de diseño de Fake Store.
class AppTheme {
  AppTheme._();

  /// Obtiene el tema claro.
  static ThemeData get lightTheme => FakeStoreTheme.light();

  /// Obtiene el tema oscuro.
  static ThemeData get darkTheme => FakeStoreTheme.dark();

  /// Obtiene los tokens del tema desde el contexto.
  static DSThemeData tokens(BuildContext context) => FakeStoreTheme.of(context);
}
