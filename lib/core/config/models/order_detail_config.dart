import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/config/models/shipping_info_config.dart';

/// Order detail page configuration.
class OrderDetailConfig extends Equatable {
  const OrderDetailConfig({
    required this.pageTitle,
    required this.sections,
    required this.labels,
    required this.shippingInfo,
  });

  factory OrderDetailConfig.fromJson(Map<String, dynamic> json) {
    return OrderDetailConfig(
      pageTitle: json['pageTitle'] as String,
      sections: Map<String, String>.from(
        json['sections'] as Map<String, dynamic>,
      ),
      labels: Map<String, String>.from(json['labels'] as Map<String, dynamic>),
      shippingInfo: ShippingInfoConfig.fromJson(
        json['shippingInfo'] as Map<String, dynamic>,
      ),
    );
  }

  final String pageTitle;
  final Map<String, String> sections;
  final Map<String, String> labels;
  final ShippingInfoConfig shippingInfo;

  @override
  List<Object?> get props => [pageTitle, sections, labels, shippingInfo];
}
