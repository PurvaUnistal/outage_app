import 'package:equatable/equatable.dart';
import 'package:igl_outage_app/features/Login/domain/model/login_model.dart';

abstract class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePageLoadState extends HomeState {
  @override
  List<Object> get props => [];
}


class FetchHomeDataState extends HomeState {
  final bool isLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;
  final List<Accessright> listOFAccessRight;


  FetchHomeDataState({
    required this.isLoader,
    required this.scheme,
    required this.baseUrl,
    required this.listOFAccessRight,
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
    listOFAccessRight,
  ];
}