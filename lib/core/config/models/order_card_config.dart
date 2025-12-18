import 'package:equatable/equatable.dart';

/// Order card configuration.
class OrderCardConfig extends Equatable {
  const OrderCardConfig({
    required this.orderLabel,
    required this.dateLabel,
    required this.totalLabel,
    required this.itemsLabel,
    required this.statusLabels,
  });

  factory OrderCardConfig.fromJson(Map<String, dynamic> json) {
    return OrderCardConfig(
      orderLabel: json['orderLabel'] as String,
      dateLabel: json['dateLabel'] as String,
      totalLabel: json['totalLabel'] as String,
      itemsLabel: json['itemsLabel'] as String,
      statusLabels: Map<String, String>.from(
        json['statusLabels'] as Map<String, dynamic>,
      ),
    );
  }

  final String orderLabel;
  final String dateLabel;
  final String totalLabel;
  final String itemsLabel;
  final Map<String, String> statusLabels;

  String getStatusLabel(String status) {
    return statusLabels[status] ?? status;
  }

  @override
  List<Object?> get props => [
    orderLabel,
    dateLabel,
    totalLabel,
    itemsLabel,
    statusLabels,
  ];
}
