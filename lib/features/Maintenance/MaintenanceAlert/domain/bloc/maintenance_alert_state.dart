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
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;

  FetchMaintenanceAlertDataState({
    required this.isLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
  });

  @override
  List<Object?> get props => [
        isLoader,
        scheme,
        userName,
        role,
        baseUrl,
      ];
}
