import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';

/// Empty cart view.
class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return DSEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      description: 'Add products to start shopping',
      actionText: 'Browse products',
      onAction: () => Navigator.pushNamed(context, Routes.products),
    );
  }
}
