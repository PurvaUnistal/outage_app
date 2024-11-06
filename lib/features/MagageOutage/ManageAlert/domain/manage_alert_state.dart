import 'package:equatable/equatable.dart';

abstract class ManageAlertState extends Equatable {}

class ManageAlertInitialState extends ManageAlertState {
  @override
  List<Object> get props => [];
}

class ManageAlertPageLoadState extends ManageAlertState {
  @override
  List<Object> get props => [];
}


class FetchManageAlertDataState extends ManageAlertState {
  final bool isLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;


  FetchManageAlertDataState({
    required this.isLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
  });
  @override
  List<Object> get props => [
    isLoader,
    scheme,
    userName,
    role,
    baseUrl,
  ];
}