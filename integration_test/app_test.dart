import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/integration_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch Tests', () {
    setUpAll(() async {
      await IntegrationTestHelpers.initializeApp();
    });

    tearDownAll(() async {
      await IntegrationTestHelpers.cleanup();
    });

    testWidgets('App should launch successfully', (tester) async {
      await IntegrationTestHelpers.pumpApp(tester);

      // Verify that the app launched successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Home page should display bottom navigation', (tester) async {
      await IntegrationTestHelpers.pumpApp(tester);
      await IntegrationTestHelpers.waitForAppLoad(tester);

      // Verify that bottom navigation exists
      expect(IntegrationFinders.bottomNav, findsOneWidget);
    });
  });
}
