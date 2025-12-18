import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSErrorState', () {
    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSErrorState(message: 'Something went wrong'),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byType(DSErrorState), findsOneWidget);
    });

    testWidgets('renders retry button and responds to tap', (tester) async {
      bool wasRetried = false;

      await tester.pumpWidget(
        buildTestableWidget(
          DSErrorState(
            message: 'Network error',
            onRetry: () => wasRetried = true,
          ),
        ),
      );

      expect(find.byType(DSButton), findsOneWidget);

      await tester.tap(find.byType(DSButton));
      await tester.pumpAndSettle();
      expect(wasRetried, true);
    });

    testWidgets('renders error details when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSErrorState(
            message: 'Error occurred',
            details: 'Error code: 500 - Internal Server Error',
          ),
        ),
      );

      expect(find.text('Error occurred'), findsOneWidget);
      expect(
        find.text('Error code: 500 - Internal Server Error'),
        findsOneWidget,
      );
    });

    testWidgets('does not render retry button when onRetry is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(const DSErrorState(message: 'Permanent error')),
      );

      expect(find.text('Permanent error'), findsOneWidget);
      expect(find.byType(DSButton), findsNothing);
    });

    testWidgets('renders error icon', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const DSErrorState(message: 'Error with icon')),
      );

      // DSErrorState should show an error icon
      expect(find.byType(Icon), findsWidgets);
    });
  });
}
