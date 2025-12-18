import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/constants/app_constants.dart';

/// Quantity selector with increment/decrement buttons.
///
/// Allows selecting a quantity within a defined range.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = AppConstants.minCartQuantity,
    this.max = AppConstants.maxCartQuantity,
  });

  /// Current quantity.
  final int quantity;

  /// Callback when the quantity changes.
  final ValueChanged<int> onChanged;

  /// Minimum allowed quantity.
  final int min;

  /// Maximum allowed quantity.
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DSIconButton(
          icon: Icons.remove,
          onPressed: quantity > min ? () => onChanged(quantity - 1) : null,
          size: DSButtonSize.small,
        ),
        Container(
          width: DSSizes.buttonSm,
          alignment: Alignment.center,
          child: DSText('$quantity', variant: DSTextVariant.titleMedium),
        ),
        DSIconButton(
          icon: Icons.add,
          onPressed: quantity < max ? () => onChanged(quantity + 1) : null,
          size: DSButtonSize.small,
        ),
      ],
    );
  }
}
