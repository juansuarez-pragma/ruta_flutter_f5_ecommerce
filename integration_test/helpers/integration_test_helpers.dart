import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/app.dart';
import 'package:ecommerce/core/di/injection_container.dart' as di;

/// Helper class for configuring and running integration tests.
class IntegrationTestHelpers {
  static final _sl = GetIt.instance;

  /// Initializes the app for integration tests.
  ///
  /// Should be called in each test group's setUp.
  static Future<void> initializeApp() async {
    // Clean previous dependencies, if any
    if (_sl.isRegistered<SharedPreferences>()) {
      await _sl.reset();
    }

    // SharedPreferences mock for tests
    SharedPreferences.setMockInitialValues({});

    // Initialize dependencies
    await di.initDependencies();
  }

  /// Cleans dependencies after tests.
  ///
  /// Should be called in each test group's tearDown.
  static Future<void> cleanup() async {
    await _sl.reset();
  }

  /// Builds and pumps the app for testing.
  static Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();
  }

  /// Waits for the app to fully load.
  static Future<void> waitForAppLoad(WidgetTester tester) async {
    // Wait for loaders to disappear
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Clears persisted data (cart, orders).
  static Future<void> clearPersistedData() async {
    final prefs = _sl<SharedPreferences>();
    await prefs.clear();
  }
}

/// Extension methods for WidgetTester in integration tests.
extension IntegrationTesterX on WidgetTester {
  /// Taps and waits for the UI to settle.
  Future<void> tapAndSettle(Finder finder, {Duration? timeout}) async {
    await tap(finder);
    await pumpAndSettle(timeout ?? const Duration(seconds: 2));
  }

  /// Scrolls until a widget becomes visible.
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

  /// Enters text into a text field.
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Navigates back.
  Future<void> goBack() async {
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tapAndSettle(backButton);
    } else {
      // Try the system navigation back button
      final navigator = find.byType(BackButton);
      if (navigator.evaluate().isNotEmpty) {
        await tapAndSettle(navigator);
      }
    }
  }
}

/// Common finders for integration tests.
class IntegrationFinders {
  /// Finds the "Add to cart" button.
  static Finder get addToCartButton => find.text('Add to cart');

  /// Finds the checkout button.
  static Finder get checkoutButton => find.text('Proceed to checkout');

  /// Finds the search field.
  static Finder get searchField => find.byType(TextField);

  /// Finds the BottomNavigationBar.
  static Finder get bottomNav => find.byType(BottomNavigationBar);

  /// Finds a product by title.
  static Finder productByTitle(String title) => find.text(title);

  /// Finds a button by its text.
  static Finder buttonWithText(String text) => find.text(text);

  /// Finds the cart icon.
  static Finder get cartIcon => find.byIcon(Icons.shopping_cart);

  /// Finds the search icon.
  static Finder get searchIcon => find.byIcon(Icons.search);
}
