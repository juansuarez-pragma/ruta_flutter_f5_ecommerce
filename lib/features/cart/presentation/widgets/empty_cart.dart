import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../../../core/router/routes.dart';

/// Vista para carrito vacío.
class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return DSEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Tu carrito está vacío',
      description: 'Agrega productos para comenzar a comprar',
      actionText: 'Ver productos',
      onAction: () => Navigator.pushNamed(context, Routes.products),
    );
  }
}
