import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSEmptyState', () {
    testWidgets('renders with title, description and icon', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSEmptyState(
            icon: Icons.inbox,
            title: 'No items',
            description: 'There are no items to display',
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
      expect(find.text('There are no items to display'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders action button and responds to tap', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          DSEmptyState(
            icon: Icons.search,
            title: 'No results',
            description: 'Try a different search',
            actionText: 'Search Again',
            onAction: () => wasPressed = true,
          ),
        ),
      );

      expect(find.text('Search Again'), findsOneWidget);

      await tester.tap(find.text('Search Again'));
      await tester.pumpAndSettle();
      expect(wasPressed, true);
    });

    testWidgets('does not render action button when onAction is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSEmptyState(
            icon: Icons.warning,
            title: 'Warning',
            description: 'Something happened',
          ),
        ),
      );

      expect(find.byType(DSButton), findsNothing);
    });

    testWidgets('renders without description', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSEmptyState(
            icon: Icons.folder,
            title: 'Empty Folder',
          ),
        ),
      );

      expect(find.text('Empty Folder'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
    });
  });
}
