import 'package:flutter/material.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';

/// Product grid using DSProductCard.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount = 2,
  });

  /// Products to display.
  final List<Product> products;

  /// Number of grid columns.
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(DSSpacing.base),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.65,
        crossAxisSpacing: DSSpacing.sm,
        mainAxisSpacing: DSSpacing.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return DSProductCard(
          imageUrl: product.image,
          title: product.title,
          price: product.price,
          rating: product.rating.rate,
          reviewCount: product.rating.count,
          onTap: () => Navigator.pushNamed(
            context,
            Routes.productDetailPath(product.id),
          ),
        );
      },
    );
  }
}
