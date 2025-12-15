import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSCard', () {
    testWidgets('renders child content correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const DSCard(child: Text('Card Content'))),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(DSCard), findsOneWidget);
    });

    testWidgets('responds to tap when onTap is provided', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          DSCard(
            onTap: () => wasTapped = true,
            child: const Text('Tappable Card'),
          ),
        ),
      );

      await tester.tap(find.byType(DSCard));
      expect(wasTapped, true);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSCard(
            padding: EdgeInsets.all(24),
            child: Text('Custom Padding'),
          ),
        ),
      );

      expect(find.text('Custom Padding'), findsOneWidget);
    });

    testWidgets('applies custom borderRadius', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSCard(borderRadius: 16.0, child: Text('Rounded Card')),
        ),
      );

      expect(find.text('Rounded Card'), findsOneWidget);
    });

    testWidgets('applies custom elevation', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSCard(elevation: 4, child: Text('Elevated Card')),
        ),
      );

      expect(find.text('Elevated Card'), findsOneWidget);
    });

    testWidgets('renders complex child widgets', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSCard(
            child: Column(
              children: [Text('Title'), Text('Subtitle'), Icon(Icons.star)],
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
