import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../../../core/utils/extensions.dart';

/// Tile para mostrar una categoría.
class CategoryTile extends StatelessWidget {
  /// Nombre de la categoría.
  final String category;

  /// Callback cuando se toca la categoría.
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tokens.colorBrandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DSBorderRadius.base),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: tokens.colorBrandPrimary,
            ),
          ),
          const SizedBox(width: DSSpacing.base),
          Expanded(
            child: DSText(
              category.titleCase,
              variant: DSTextVariant.titleMedium,
            ),
          ),
          Icon(Icons.chevron_right, color: tokens.colorTextTertiary),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'jewelery':
        return Icons.diamond;
      case "men's clothing":
        return Icons.male;
      case "women's clothing":
        return Icons.female;
      default:
        return Icons.category;
    }
  }
}
