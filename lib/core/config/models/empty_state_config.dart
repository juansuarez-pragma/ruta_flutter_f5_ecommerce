import 'package:equatable/equatable.dart';

/// Empty state configuration.
class EmptyStateConfig extends Equatable {
  const EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory EmptyStateConfig.fromJson(Map<String, dynamic> json) {
    return EmptyStateConfig(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  final String icon;
  final String title;
  final String description;

  @override
  List<Object?> get props => [icon, title, description];
}
