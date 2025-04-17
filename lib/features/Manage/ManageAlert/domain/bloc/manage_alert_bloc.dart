import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/model/ViewIncidentModel.dart';
import 'package:outage_app/features/Manage/ManageAlert/helper/manage_alert_helper.dart';
import 'manage_alert_event.dart';
import 'manage_alert_state.dart';

class ManageAlertBloc extends Bloc<ManageAlertEvent, ManageAlertState> {
  ManageAlertBloc() : super(ManageAlertInitialState()) {
    on<ManageAlertLoadEvent>(_pageLoad);
    on<SelectTabChangedEvent>(_selectTabChanged);
    on<SelectPageSelectDataEvent>(_selectPageSelectData);
    on<ManagePageRefreshDataEvent>(_pageRefreshData);
    on<SelectSearchPriorityEvent>(_selectSearchPriority);
  }

  bool isLoader = false;
  bool tabIndexLoader = false;
  String role = '';
  String baseUrl = '';
  int tabIndex = 0;

  ViewIncidentModel viewIncidentModel = ViewIncidentModel();
  ViewIncidentData viewIncidentValue = ViewIncidentData();
  List<ViewIncidentData> listOfViewIncident = [];
  List<ViewIncidentData> listOfFilterViewIncident = [];



  TextEditingController searchPriorityController = TextEditingController();

  _pageLoad(ManageAlertLoadEvent event, emit) async {
    emit(ManageAlertPageLoadState());
    isLoader = false;
    tabIndexLoader = false;
    tabIndex = 0;

    viewIncidentModel = ViewIncidentModel();
    viewIncidentValue = ViewIncidentData();
    listOfViewIncident = [];
    listOfFilterViewIncident = [];
    searchPriorityController.text = "";
    role = await AppConfig.instanceInit()?.loginData.user?.role! ?? "";
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
        listOfFilterViewIncident = listOfViewIncident;
        _filterList();
      }
      return res;
    }
  }

   _filterList() {
    ActionStatus? status;

    if (tabIndex == 0) {
      status = ActionStatus.newAction;
    } else if (tabIndex == 1) {
      status = ActionStatus.inProgress;
    } else if (tabIndex == 2) {
      status = ActionStatus.completed;
    }

    if (status != null) {
      listOfFilterViewIncident = listOfViewIncident
          .where((e) => e.actionStatus == status)
          .toList();
    } else {
      listOfFilterViewIncident = listOfViewIncident;
    }
  }


  _selectTabChanged(SelectTabChangedEvent event, emit) async {
    searchPriorityController.text = "";
    tabIndex = event.tabIndex;
      tabIndexLoader = true;
    _eventCompleted(emit);
      await _fetchViewIncidentApi(context: event.context);
    tabIndexLoader = false;
    _eventCompleted(emit);
  }

  _selectPageSelectData(SelectPageSelectDataEvent event, emit) async {
    viewIncidentValue = listOfViewIncident[event.index];
   await _filterList();
    _eventCompleted(emit);
  }

  _pageRefreshData(ManagePageRefreshDataEvent event, emit) async {
    await _fetchViewIncidentApi(context: event.context);
    await _filterList();
    _eventCompleted(emit);
  }


  _selectSearchPriority(SelectSearchPriorityEvent event, emit) async {
    searchPriorityController.text = event.searchPriority;
    if (event.searchPriority.isNotEmpty) {
      listOfFilterViewIncident = listOfFilterViewIncident
          .where((element) =>
              element.priority!.toString().contains(event.searchPriority) ||
              element.priority!.startsWith(event.searchPriority.toString()))
          .toList();
      _eventCompleted(emit);
    } else {
      listOfFilterViewIncident = await listOfViewIncident;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<ManageAlertState> emit) {
    emit(FetchManageAlertDataState(
      isLoader: isLoader,
      tabIndexLoader: tabIndexLoader,
      baseUrl: baseUrl,
      role: role,
      tabIndex: tabIndex,
      searchPriorityController: searchPriorityController,
      viewIncidentModel: viewIncidentModel,
      viewIncidentValue: viewIncidentValue,
      listOfViewIncident: listOfViewIncident,
      listOfFilterViewIncident: listOfFilterViewIncident,
    ));
  }
}
