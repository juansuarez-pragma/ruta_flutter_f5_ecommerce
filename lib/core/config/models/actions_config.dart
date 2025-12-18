import 'package:equatable/equatable.dart';

/// Configuración de acciones.
class ActionsConfig extends Equatable {
  const ActionsConfig({required this.viewDetails, required this.reorder});

  factory ActionsConfig.fromJson(Map<String, dynamic> json) {
    return ActionsConfig(
      viewDetails: json['viewDetails'] as String,
      reorder: json['reorder'] as String,
    );
  }

  final String viewDetails;
  final String reorder;

  @override
  List<Object?> get props => [viewDetails, reorder];
}

