import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSButton', () {
    testWidgets('renders primary button correctly', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(text: 'Test Button', onPressed: () => wasPressed = true),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(DSButton), findsOneWidget);

      await tester.tap(find.byType(DSButton));
      expect(wasPressed, true);
    });

    testWidgets('renders secondary button correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(
            text: 'Secondary',
            variant: DSButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('renders ghost button correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(
            text: 'Ghost',
            variant: DSButtonVariant.ghost,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets('renders danger button correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(
            text: 'Danger',
            variant: DSButtonVariant.danger,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Danger'), findsOneWidget);
    });

    testWidgets('renders disabled button when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(const DSButton(text: 'Disabled')),
      );

      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('renders button with icon', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(text: 'With Icon', icon: Icons.add, onPressed: () {}),
        ),
      );

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows loading state correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DSButton(text: 'Loading', isLoading: true, onPressed: () {}),
        ),
      );

      // DSButton muestra un indicador de carga en estado loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders different sizes', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              DSButton(
                text: 'Small',
                size: DSButtonSize.small,
                onPressed: () {},
              ),
              DSButton(text: 'Medium', onPressed: () {}),
              DSButton(
                text: 'Large',
                size: DSButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });
  });
}
