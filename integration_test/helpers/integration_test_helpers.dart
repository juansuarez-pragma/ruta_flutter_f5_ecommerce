import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/app.dart';
import 'package:ecommerce/core/di/injection_container.dart' as di;

/// Helper class para configurar y ejecutar integration tests.
class IntegrationTestHelpers {
  static final _sl = GetIt.instance;

  /// Inicializa la app para integration tests.
  ///
  /// Debe llamarse en el setUp de cada test group.
  static Future<void> initializeApp() async {
    // Limpiar dependencias previas si existen
    if (_sl.isRegistered<SharedPreferences>()) {
      await _sl.reset();
    }

    // Mock de SharedPreferences para tests
    SharedPreferences.setMockInitialValues({});

    // Inicializar dependencias
    await di.initDependencies();
  }

  /// Limpia las dependencias después de los tests.
  ///
  /// Debe llamarse en el tearDown de cada test group.
  static Future<void> cleanup() async {
    await _sl.reset();
  }

  /// Construye y lanza la app para testing.
  static Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();
  }

  /// Espera a que la app cargue completamente.
  static Future<void> waitForAppLoad(WidgetTester tester) async {
    // Esperar a que desaparezcan los loaders
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Limpia datos persistidos (carrito, órdenes).
  static Future<void> clearPersistedData() async {
    final prefs = _sl<SharedPreferences>();
    await prefs.clear();
  }
}

/// Extension methods para WidgetTester en integration tests.
extension IntegrationTesterX on WidgetTester {
  /// Tap y espera a que se estabilice la UI.
  Future<void> tapAndSettle(Finder finder, {Duration? timeout}) async {
    await tap(finder);
    await pumpAndSettle(timeout ?? const Duration(seconds: 2));
  }

  /// Scroll hasta encontrar un widget.
  Future<void> scrollUntilVisible(
    Finder finder,
    Finder scrollable, {
    double delta = 100,
    int maxScrolls = 50,
  }) async {
    var scrollCount = 0;
    while (!finder.evaluate().isNotEmpty && scrollCount < maxScrolls) {
      await drag(scrollable, Offset(0, -delta));
      await pumpAndSettle();
      scrollCount++;
    }
  }

  /// Ingresa texto en un campo de texto.
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Navega hacia atrás.
  Future<void> goBack() async {
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tapAndSettle(backButton);
    } else {
      // Intentar con el botón de navegación del sistema
      final navigator = find.byType(BackButton);
      if (navigator.evaluate().isNotEmpty) {
        await tapAndSettle(navigator);
      }
    }
  }
}

/// Finders comunes para integration tests.
class IntegrationFinders {
  /// Encuentra el botón de agregar al carrito.
  static Finder get addToCartButton => find.text('Agregar al carrito');

  /// Encuentra el botón de checkout.
  static Finder get checkoutButton => find.text('Proceder al pago');

  /// Encuentra el campo de búsqueda.
  static Finder get searchField => find.byType(TextField);

  /// Encuentra el BottomNavigationBar.
  static Finder get bottomNav => find.byType(BottomNavigationBar);

  /// Encuentra un producto por su título.
  static Finder productByTitle(String title) => find.text(title);

  /// Encuentra un botón por su texto.
  static Finder buttonWithText(String text) => find.text(text);

  /// Encuentra el icono del carrito.
  static Finder get cartIcon => find.byIcon(Icons.shopping_cart);

  /// Encuentra el icono de búsqueda.
  static Finder get searchIcon => find.byIcon(Icons.search);
}
