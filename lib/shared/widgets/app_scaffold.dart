import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/cart/cart.dart';

/// Main scaffold with bottom navigation.
///
/// Provides the base structure for the main screens of the app.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.title,
    this.actions,
    this.showBottomNav = true,
    this.floatingActionButton,
    this.leading,
  });

  /// Screen body widget.
  final Widget body;

  /// Current bottom navigation index.
  final int currentIndex;

  /// Optional AppBar title.
  final String? title;

  /// Optional AppBar actions.
  final List<Widget>? actions;

  /// Whether the bottom navigation bar should be shown.
  final bool showBottomNav;

  /// Optional floating action button.
  final FloatingActionButton? floatingActionButton;

  /// Optional leading widget for the AppBar.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? DSAppBar(title: title, actions: actions, leading: leading)
          : null,
      body: body,
      bottomNavigationBar: showBottomNav ? _buildBottomNav(context) : null,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartCount = state is CartLoaded ? state.totalItems : 0;

        return DSBottomNav(
          currentIndex: currentIndex,
          onTap: (index) => _onNavTap(context, index),
          items: [
            const DSBottomNavItem(icon: Icons.home, label: 'Home'),
            const DSBottomNavItem(icon: Icons.grid_view, label: 'Products'),
            DSBottomNavItem(
              icon: Icons.shopping_cart,
              label: 'Cart',
              badgeCount: cartCount > 0 ? cartCount : null,
            ),
            const DSBottomNavItem(icon: Icons.person, label: 'Profile'),
          ],
        );
      },
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
      case 1:
        Navigator.pushNamed(context, Routes.products);
      case 2:
        Navigator.pushNamed(context, Routes.cart);
      case 3:
        Navigator.pushNamed(context, Routes.profile);
    }
  }
}
