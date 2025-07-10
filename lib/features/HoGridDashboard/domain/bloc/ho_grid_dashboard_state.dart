import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

abstract class HoGridDashboardState extends Equatable {}

class HoGridDashboardInitialState extends HoGridDashboardState {
  @override
  List<Object> get props => [];
}

class HoGridDashboardPageLoadState extends HoGridDashboardState {
  @override
  List<Object> get props => [];
}

class FetchHoGridDashboardDataState extends HoGridDashboardState {
  final bool isPageLoader;
  final Dashboard dashboard;
  final List<GridData> listOfGridData;

  FetchHoGridDashboardDataState({
    required this.isPageLoader,
    required this.dashboard,
    required this.listOfGridData,
  });

  @override
  List<Object> get props => [
    isPageLoader,
    dashboard,
    listOfGridData,
  ];
}
