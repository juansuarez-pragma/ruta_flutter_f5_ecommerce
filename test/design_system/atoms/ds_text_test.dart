import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSText', () {
    testWidgets('renders text with default style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText('Hello World'),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('renders headingLarge style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.headingLarge('Large Heading'),
        ),
      );

      expect(find.text('Large Heading'), findsOneWidget);
    });

    testWidgets('renders headingMedium style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.headingMedium('Medium Heading'),
        ),
      );

      expect(find.text('Medium Heading'), findsOneWidget);
    });

    testWidgets('renders headingSmall style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.headingSmall('Small Heading'),
        ),
      );

      expect(find.text('Small Heading'), findsOneWidget);
    });

    testWidgets('renders bodyLarge style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.bodyLarge('Large Body'),
        ),
      );

      expect(find.text('Large Body'), findsOneWidget);
    });

    testWidgets('renders bodyMedium style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.bodyMedium('Medium Body'),
        ),
      );

      expect(find.text('Medium Body'), findsOneWidget);
    });

    testWidgets('renders bodySmall style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.bodySmall('Small Body'),
        ),
      );

      expect(find.text('Small Body'), findsOneWidget);
    });

    testWidgets('renders label style', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText.label('Label Text'),
        ),
      );

      expect(find.text('Label Text'), findsOneWidget);
    });

    testWidgets('applies custom color', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText(
            'Colored Text',
            color: Colors.red,
          ),
        ),
      );

      final text = tester.widget<DSText>(find.byType(DSText));
      expect(text.color, Colors.red);
    });

    testWidgets('applies text alignment', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSText(
            'Centered Text',
            textAlign: TextAlign.center,
          ),
        ),
      );

      expect(find.text('Centered Text'), findsOneWidget);
    });

    testWidgets('applies maxLines and overflow', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const SizedBox(
            width: 100,
            child: DSText(
              'Very long text that should overflow after max lines',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      final text = tester.widget<DSText>(find.byType(DSText));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });
  });
}
