import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/Manage/IncidentManage/domain/model/ViewIncidentModel.dart';

abstract class IncidentManageState extends Equatable {}

class IncidentManageInitialState extends IncidentManageState {
  @override
  List<Object> get props => [];
}

class IncidentManagePageLoadState extends IncidentManageState {
  @override
  List<Object> get props => [];
}


class FetchIncidentManageDataState extends IncidentManageState {
  final bool isLoader;
  final bool tabIndexLoader;
  final String role;
  final String baseUrl;
  final int tabIndex;
  final TextEditingController searchPriorityController;
  final ViewIncidentModel viewIncidentModel;
  final ViewIncidentData viewIncidentValue;
  final List<ViewIncidentData> listOfViewIncident;
  final List<ViewIncidentData> listOfFilterViewIncident;


  FetchIncidentManageDataState({
    required this.isLoader,
    required this.tabIndexLoader,
    required this.baseUrl,
    required this.role,
    required this.tabIndex,
    required this.searchPriorityController,
    required this.viewIncidentModel,
    required this.viewIncidentValue,
    required this.listOfViewIncident,
    required this.listOfFilterViewIncident,

  });
  @override
  List<Object> get props => [
    isLoader,
    tabIndexLoader,
    role,
    baseUrl,
    tabIndex,
    searchPriorityController,
    viewIncidentModel,
    viewIncidentValue,
    listOfViewIncident,
    listOfFilterViewIncident,
  ];
}