import 'package:equatable/equatable.dart';

/// Images configuration.
class ImagesConfig extends Equatable {
  const ImagesConfig({
    required this.emptyOrdersPlaceholder,
    required this.orderSuccessIcon,
  });

  factory ImagesConfig.fromJson(Map<String, dynamic> json) {
    return ImagesConfig(
      emptyOrdersPlaceholder: json['emptyOrdersPlaceholder'] as String,
      orderSuccessIcon: json['orderSuccessIcon'] as String,
    );
  }

  final String emptyOrdersPlaceholder;
  final String orderSuccessIcon;

  @override
  List<Object?> get props => [emptyOrdersPlaceholder, orderSuccessIcon];
}
