import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class NavigateAlertState extends Equatable {}

class NavigateAlertInitialState extends NavigateAlertState {
  @override
  List<Object> get props => [];
}

class NavigateAlertPageLoadState extends NavigateAlertState {
  @override
  List<Object> get props => [];
}


class FetchNavigateAlertDataState extends NavigateAlertState {
  final bool isLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;
  final MapType currentMapType;
  final Set<Marker> markers;


  FetchNavigateAlertDataState({
    required this.isLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
    required this.currentMapType,
    required this.markers,
  });
  @override
  List<Object> get props => [
    isLoader,
    scheme,
    userName,
    role,
    baseUrl,
    currentMapType,
    markers,
  ];
}