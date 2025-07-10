import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

abstract class HoDistrictDashboardState extends Equatable {}

class HoDistrictDashboardInitialState extends HoDistrictDashboardState {
  @override
  List<Object> get props => [];
}

class HoDistrictDashboardPageLoadState extends HoDistrictDashboardState {
  @override
  List<Object> get props => [];
}

class FetchHoDistrictDashboardDataState extends HoDistrictDashboardState {
  final bool isPageLoader;
  final Dashboard dashboard;
  final List<DistrictData> listOfDistrictData;

  FetchHoDistrictDashboardDataState({
    required this.isPageLoader,
    required this.dashboard,
    required this.listOfDistrictData,
  });

  @override
  List<Object> get props => [isPageLoader, dashboard, listOfDistrictData];
}
