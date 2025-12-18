import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/config/models/images_config.dart';
import 'package:ecommerce/core/config/models/order_detail_config.dart';
import 'package:ecommerce/core/config/models/order_history_config.dart';
import 'package:ecommerce/core/config/models/settings_config.dart';

/// Application configuration loaded from JSON.
///
/// Allows configuring texts, images, and settings without code changes.
class AppConfig extends Equatable {
  const AppConfig({
    required this.orderHistory,
    required this.orderDetail,
    required this.images,
    required this.settings,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      orderHistory: OrderHistoryConfig.fromJson(
        json['orderHistory'] as Map<String, dynamic>,
      ),
      orderDetail: OrderDetailConfig.fromJson(
        json['orderDetail'] as Map<String, dynamic>,
      ),
      images: ImagesConfig.fromJson(json['images'] as Map<String, dynamic>),
      settings: SettingsConfig.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
    );
  }

  final OrderHistoryConfig orderHistory;
  final OrderDetailConfig orderDetail;
  final ImagesConfig images;
  final SettingsConfig settings;

  @override
  List<Object?> get props => [orderHistory, orderDetail, images, settings];
}
