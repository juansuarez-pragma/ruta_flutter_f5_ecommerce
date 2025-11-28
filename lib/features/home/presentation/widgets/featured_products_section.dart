import 'package:flutter/material.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';

/// Sección de productos destacados para el home.
class FeaturedProductsSection extends StatelessWidget {
  /// Lista de productos destacados.
  final List<Product> products;

  const FeaturedProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DSText(
                'Productos Destacados',
                variant: DSTextVariant.titleLarge,
              ),
              DSButton(
                text: 'Ver todos',
                variant: DSButtonVariant.ghost,
                size: DSButtonSize.small,
                onPressed: () => Navigator.pushNamed(context, Routes.products),
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
        ),
      ],
    );
  }
}
