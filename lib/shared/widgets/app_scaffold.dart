import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/cart/cart.dart';

/// Scaffold principal con navegación inferior.
///
/// Proporciona la estructura base para las pantallas principales
/// de la aplicación con bottom navigation bar.
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

  /// Widget del cuerpo de la pantalla.
  final Widget body;

  /// Índice actual de la navegación.
  final int currentIndex;

  /// Título opcional para el AppBar.
  final String? title;

  /// Acciones opcionales para el AppBar.
  final List<Widget>? actions;

  /// Si se debe mostrar la navegación inferior.
  final bool showBottomNav;

  /// Floating action button opcional.
  final FloatingActionButton? floatingActionButton;

  /// Widget leading opcional para el AppBar.
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
            const DSBottomNavItem(icon: Icons.home, label: 'Inicio'),
            const DSBottomNavItem(icon: Icons.grid_view, label: 'Productos'),
            DSBottomNavItem(
              icon: Icons.shopping_cart,
              label: 'Carrito',
              badgeCount: cartCount > 0 ? cartCount : null,
            ),
            const DSBottomNavItem(icon: Icons.person, label: 'Perfil'),
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
