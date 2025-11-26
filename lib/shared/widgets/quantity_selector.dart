import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../core/constants/app_constants.dart';

/// Selector de cantidad con botones incrementar/decrementar.
///
/// Permite al usuario seleccionar una cantidad dentro de un rango definido.
class QuantitySelector extends StatelessWidget {
  /// Cantidad actual.
  final int quantity;

  /// Callback cuando la cantidad cambia.
  final ValueChanged<int> onChanged;

  /// Cantidad mínima permitida.
  final int min;

  /// Cantidad máxima permitida.
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = AppConstants.minCartQuantity,
    this.max = AppConstants.maxCartQuantity,
  });

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
          width: 40,
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
