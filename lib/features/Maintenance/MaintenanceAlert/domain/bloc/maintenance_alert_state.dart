import 'package:equatable/equatable.dart';

abstract class MaintenanceAlertState extends Equatable {}

class MaintenanceAlertInitialState extends MaintenanceAlertState {
  @override
  List<Object> get props => [];
}

class MaintenanceAlertPageLoadState extends MaintenanceAlertState {
  @override
  List<Object> get props => [];
}

class FetchMaintenanceAlertDataState extends MaintenanceAlertState {
  final bool isLoader;
  final String role;
  final String baseUrl;

  FetchMaintenanceAlertDataState({
    required this.isLoader,
    required this.baseUrl,
    required this.role,
  });

  @override
  List<Object?> get props => [
        isLoader,
        role,
        baseUrl,
      ];
}
