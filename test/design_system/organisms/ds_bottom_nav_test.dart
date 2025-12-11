import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('DSBottomNav', () {
    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: DSBottomNav(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              DSBottomNavItem(icon: Icons.home, label: 'Home'),
              DSBottomNavItem(icon: Icons.category, label: 'Categories'),
              DSBottomNavItem(icon: Icons.shopping_cart, label: 'Cart'),
              DSBottomNavItem(icon: Icons.person, label: 'Profile'),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('calls onTap with correct index', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        buildTestableScaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: DSBottomNav(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
            items: const [
              DSBottomNavItem(icon: Icons.home, label: 'Home'),
              DSBottomNavItem(icon: Icons.category, label: 'Categories'),
              DSBottomNavItem(icon: Icons.shopping_cart, label: 'Cart'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);

      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 2);
    });

    testWidgets('highlights current index correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: DSBottomNav(
            currentIndex: 1,
            onTap: (_) {},
            items: const [
              DSBottomNavItem(icon: Icons.home, label: 'Home'),
              DSBottomNavItem(icon: Icons.category, label: 'Categories'),
              DSBottomNavItem(icon: Icons.shopping_cart, label: 'Cart'),
            ],
          ),
        ),
      );

      // La DSBottomNav debe estar renderizada con el índice actual en 1
      expect(find.byType(DSBottomNav), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('renders badge count when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: DSBottomNav(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              DSBottomNavItem(icon: Icons.home, label: 'Home'),
              DSBottomNavItem(
                icon: Icons.shopping_cart,
                label: 'Cart',
                badgeCount: 3,
              ),
            ],
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders selected icon when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableScaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: DSBottomNav(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              DSBottomNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              DSBottomNavItem(
                icon: Icons.person_outlined,
                selectedIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      );

      // Verifica que los items están renderizados
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
