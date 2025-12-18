import 'package:equatable/equatable.dart';

/// Shipping information configuration.
class ShippingInfoConfig extends Equatable {
  const ShippingInfoConfig({
    required this.title,
    required this.freeShipping,
    required this.estimatedDelivery,
  });

  factory ShippingInfoConfig.fromJson(Map<String, dynamic> json) {
    return ShippingInfoConfig(
      title: json['title'] as String,
      freeShipping: json['freeShipping'] as String,
      estimatedDelivery: json['estimatedDelivery'] as String,
    );
  }

  final String title;
  final String freeShipping;
  final String estimatedDelivery;

  @override
  List<Object?> get props => [title, freeShipping, estimatedDelivery];
}
