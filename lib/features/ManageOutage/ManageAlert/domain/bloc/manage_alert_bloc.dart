import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/model/ViewIncidentModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/helper/manage_alert_helper.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/presentation/report_details_view.dart';
import 'manage_alert_event.dart';
import 'manage_alert_state.dart';

class ManageAlertBloc extends Bloc<ManageAlertEvent, ManageAlertState> {
  ManageAlertBloc() : super(ManageAlertInitialState()) {
    on<ManageAlertLoadEvent>(_pageLoad);
    on<SelectTabChangedEvent>(_selectTabChanged);
    on<SelectReportChangedEvent>(_selectReportChanged);
  }

  bool isLoader = false;
  bool tabIndexLoader = false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  int tabIndex = 0;
  ViewIncidentModel viewIncidentModel = ViewIncidentModel();
  ViewIncidentData viewIncidentValue = ViewIncidentData();
  List<ViewIncidentData> listOfViewIncident = [];
  List<ViewIncidentData> listOfNewViewIncident = [];
  List<ViewIncidentData> listOfProgressViewIncident = [];
  List<ViewIncidentData> listOfCompletedViewIncident = [];

  List<Tab> listOfTab = [
    Tab(text: "New"),
    Tab(text: "In Progress"),
    Tab(text: "Completed"),
  ];


  _pageLoad(ManageAlertLoadEvent event, emit) async {
    emit(ManageAlertInitialState());
    isLoader = false;
    tabIndexLoader = false;
    tabIndex = 0;
    viewIncidentModel = ViewIncidentModel();
    viewIncidentValue = ViewIncidentData();
    listOfViewIncident = [];
    listOfNewViewIncident = [];
    listOfProgressViewIncident = [];
    listOfCompletedViewIncident = [];
    listOfTab = listOfTab;

    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await _fetchViewIncidentApi(context: event.context);
    _eventCompleted(emit);
  }

  _fetchViewIncidentApi({
    required BuildContext context,
  }) async {
    var res = await ManageAlertHelper.getViewIncidentApi(
      context: context,
    );
    if (res != null) {
      viewIncidentModel = res;
      if (viewIncidentModel.data != null) {
        listOfViewIncident = viewIncidentModel.data!;
        listOfNewViewIncident = listOfViewIncident
            .where((element) => element.actionStatus == "0")
            .toList();
        listOfProgressViewIncident = listOfViewIncident
            .where((element) => element.actionStatus == "1")
            .toList();
        listOfCompletedViewIncident = listOfViewIncident
            .where((element) => element.actionStatus == "4")
            .toList();
      }
      return res;
    }
  }

  _selectTabChanged(SelectTabChangedEvent event, emit) async {
    tabIndex = event.tabIndex;
    tabIndexLoader = true;
    _eventCompleted(emit);
    await _fetchViewIncidentApi(context: event.context);
    tabIndexLoader = false;
    _eventCompleted(emit);
  }

  _selectReportChanged(SelectReportChangedEvent event, emit) async {
    /*if(event.incidentTypeId.isNotEmpty){
      await SharedPref.setString(key: PrefsValue.incidentTypeId,value: event.incidentTypeId.toString());
      await SharedPref.setString(key: PrefsValue.incidentId,value: event.incidentId.toString());
      print("event.incidentTypeId-->${event.incidentTypeId}");
      print("event.incidentId-->${event.incidentId}");
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (buildContext) => const ReportDetailsView()),
      );
      _eventCompleted(emit);
    }*/
  }

  _eventCompleted(Emitter<ManageAlertState> emit) {
    emit(FetchManageAlertDataState(
      isLoader: isLoader,
      tabIndexLoader: tabIndexLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
      tabIndex: tabIndex,
      listOfTab:listOfTab,
      viewIncidentModel: viewIncidentModel,
      viewIncidentValue: viewIncidentValue,
      listOfViewIncident: listOfViewIncident,
      listOfNewViewIncident: listOfNewViewIncident,
      listOfProgressViewIncident: listOfProgressViewIncident,
      listOfCompletedViewIncident: listOfCompletedViewIncident,
    ));
  }
}
