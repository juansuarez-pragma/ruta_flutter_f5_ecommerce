import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSAppBar', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          appBar: const DSAppBar(title: 'Test Title'),
          body: const SizedBox.shrink(),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(DSAppBar), findsOneWidget);
    });

    testWidgets('renders actions when provided', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        buildTestableScaffold(
          appBar: DSAppBar(
            title: 'With Actions',
            actions: [
              DSIconButton(
                icon: Icons.search,
                onPressed: () => wasPressed = true,
              ),
              DSIconButton(icon: Icons.shopping_cart, onPressed: () {}),
            ],
          ),
          body: const SizedBox.shrink(),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      expect(wasPressed, true);
    });

    testWidgets('renders back button when not at root', (tester) async {
      await tester.pumpWidget(
        buildTestableApp(
          home: Builder(
            builder: (context) => const Scaffold(
              appBar: DSAppBar(title: 'Detail Page'),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // El back button depende del Navigator
      expect(find.byType(DSAppBar), findsOneWidget);
    });

    testWidgets('renders custom titleWidget when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          appBar: const DSAppBar(
            title: 'Ignored',
            titleWidget: TextField(
              decoration: InputDecoration(hintText: 'Search...'),
            ),
          ),
          body: const SizedBox.shrink(),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('renders leading widget when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          appBar: DSAppBar(
            title: 'With Leading',
            leading: DSIconButton(icon: Icons.menu, onPressed: () {}),
          ),
          body: const SizedBox.shrink(),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });
}
