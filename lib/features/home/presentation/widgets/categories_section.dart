import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/utils/extensions.dart';

/// Sección de categorías para el home.
class CategoriesSection extends StatelessWidget {
  /// Lista de categorías.
  final List<String> categories;

  const CategoriesSection({super.key, required this.categories});

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
              const DSText('Categorías', variant: DSTextVariant.titleLarge),
              DSButton(
                text: 'Ver todas',
                variant: DSButtonVariant.ghost,
                size: DSButtonSize.small,
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.categories),
              ),
            ],
          ),
        ),
        const SizedBox(height: DSSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: DSSpacing.sm),
            itemBuilder: (context, index) {
              final category = categories[index];
              return DSFilterChip(
                label: category.titleCase,
                isSelected: false,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.products,
                  arguments: {'category': category},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
