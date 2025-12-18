import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/utils/extensions.dart';

/// Categories section for the Home screen.
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, required this.categories});

  /// Category list.
  final List<String> categories;

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
              const DSText('Categories', variant: DSTextVariant.titleLarge),
              DSButton(
                text: 'View all',
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
