import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/InChargeDashboard/domain/model/InChargeDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

abstract class InChargeDashboardState extends Equatable {}

class InChargeDashboardInitialState extends InChargeDashboardState {
  @override
  List<Object> get props => [];
}

class InChargeDashboardPageLoadState extends InChargeDashboardState {
  @override
  List<Object> get props => [];
}

class FetchInChargeDashboardDataState extends InChargeDashboardState {
  final bool isPageLoader;
  final Dashboard dashboard;
  final List<ModuleData> listOfInChargeData;


  FetchInChargeDashboardDataState({
    required this.isPageLoader,
    required this.dashboard,
    required this.listOfInChargeData,
  });

  @override
  List<Object> get props => [
    isPageLoader,
    dashboard,
    listOfInChargeData,
  ];
}
