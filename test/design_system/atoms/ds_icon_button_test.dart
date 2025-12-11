import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSIconButton', () {
    testWidgets('renders correctly with icon', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSIconButton(
            icon: Icons.favorite,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byType(DSIconButton), findsOneWidget);
    });

    testWidgets('responds to tap', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          DSIconButton(
            icon: Icons.add,
            onPressed: () => wasPressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(DSIconButton));
      expect(wasPressed, true);
    });

    testWidgets('renders disabled state when onPressed is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DSIconButton(
            icon: Icons.delete,
            onPressed: null,
          ),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('applies different sizes', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              DSIconButton(
                icon: Icons.settings,
                size: DSButtonSize.small,
                onPressed: () {},
              ),
              DSIconButton(
                icon: Icons.settings,
                size: DSButtonSize.medium,
                onPressed: () {},
              ),
              DSIconButton(
                icon: Icons.settings,
                size: DSButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsNWidgets(3));
    });

    testWidgets('applies different variants', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              DSIconButton(
                icon: Icons.home,
                variant: DSButtonVariant.primary,
                onPressed: () {},
              ),
              DSIconButton(
                icon: Icons.home,
                variant: DSButtonVariant.secondary,
                onPressed: () {},
              ),
              DSIconButton(
                icon: Icons.home,
                variant: DSButtonVariant.ghost,
                onPressed: () {},
              ),
              DSIconButton(
                icon: Icons.home,
                variant: DSButtonVariant.danger,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsNWidgets(4));
    });

    testWidgets('shows tooltip when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSIconButton(
            icon: Icons.info,
            tooltip: 'Information',
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSIconButton(
            icon: Icons.refresh,
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
