import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/model/ViewIncidentModel.dart';

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
  final bool tabIndexLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;
  final int tabIndex;
  final List<Tab> listOfTab;
  final ViewIncidentModel viewIncidentModel;
  final ViewIncidentData viewIncidentValue;
  final List<ViewIncidentData> listOfViewIncident;
  final List<ViewIncidentData> listOfNewViewIncident;
  final List<ViewIncidentData> listOfProgressViewIncident;
  final List<ViewIncidentData> listOfCompletedViewIncident;


  FetchManageAlertDataState({
    required this.isLoader,
    required this.tabIndexLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
    required this.tabIndex,
    required this.listOfTab,
    required this.viewIncidentModel,
    required this.viewIncidentValue,
    required this.listOfViewIncident,
    required this.listOfNewViewIncident,
    required this.listOfProgressViewIncident,
    required this.listOfCompletedViewIncident,

  });
  @override
  List<Object> get props => [
    isLoader,
    tabIndexLoader,
    scheme,
    userName,
    role,
    baseUrl,
    tabIndex,
    listOfTab,
    viewIncidentModel,
    viewIncidentValue,
    listOfViewIncident,
   listOfNewViewIncident,
    listOfProgressViewIncident,
    listOfCompletedViewIncident,
  ];
}