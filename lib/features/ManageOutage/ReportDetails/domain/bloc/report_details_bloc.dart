import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_event.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/helper/report_details_helper.dart';
import '../model/IncidentActionModel.dart';

class ReportDetailsBloc extends Bloc<ReportDetailsEvent, ReportDetailsState> {
  ReportDetailsBloc() : super(ReportDetailsInitialState()) {
    on<ReportDetailsLoadEvent>(_pageLoad);
    on<SubmitBtnEvent>(_submitBtnEvent);
  }

  bool isLoader = false;
  bool isBtnLoader = false;
  String currentActionStatus = "";
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String incidentTypeId = '';
  String incidentId = '';


  IncidentActionModel incidentActionModel = IncidentActionModel();
  List<IncidentActionData> listOfIncidentAction = [];

  IncidentTypeActionModel incidentTypeActionModel = IncidentTypeActionModel();
  List<IncidentTypeAction> listOfIncidentTypeAction = [];

  _pageLoad(ReportDetailsLoadEvent event, emit) async {
    emit(ReportDetailsInitialState());
    isLoader = false;


    isBtnLoader = false;
    incidentActionModel = IncidentActionModel();
    listOfIncidentAction = [];

     incidentTypeActionModel = IncidentTypeActionModel();
     listOfIncidentTypeAction = [];

    incidentTypeId = await SharedPref.getString(key: PrefsValue.incidentTypeId);
    incidentId = await SharedPref.getString(key: PrefsValue.incidentId);
    print("incidentTypeId-->${incidentTypeId}");
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
  //  await _fetchIncidentActionApi(context: event.context, incidentTypeId: incidentTypeId);
    await _fetchIncidentTypeActionApi(context: event.context, incidentTypeId: incidentTypeId,incidentId: incidentId);
    _eventCompleted(emit);
  }


 /* _fetchIncidentActionApi(
      {required BuildContext context, required String incidentTypeId}) async {
    var res = await ReportDetailsHelper.getIncidentActionApi(
      context: context,
      incidentTypeId: incidentTypeId,
    );
    if (res != null) {
      incidentActionModel = res;
      if (incidentActionModel.data != null) {
        listOfIncidentAction = incidentActionModel.data!;
      }
      return res;
    }
  }*/

  _fetchIncidentTypeActionApi({
        required BuildContext context,
        required String incidentTypeId,
        required String incidentId,
  }) async {
    var res = await ReportDetailsHelper.getIncidentTypeActionApi(
      context: context,
      incidentTypeId: incidentTypeId,
      incidentId: incidentId,
    );
    if (res != null) {
      incidentTypeActionModel = res;
      if (incidentTypeActionModel.data != null) {
        listOfIncidentTypeAction = incidentTypeActionModel.data!; // ye list or ha isme action status aagr null ho ya pending ho
        for(var data in listOfIncidentTypeAction){
          if(data.actionStatus == "1" ){
            break;
          } else if(data.actionStatus == null){
            data.actionStatusEnable = true;
            break;
          }else{}
        }
      }
      return res;
    }
  }

  _submitBtnEvent(SubmitBtnEvent event, emit) async {
    try{
      isBtnLoader = true;
      currentActionStatus = event.actionStatus;
      _eventCompleted(emit);
      var res = await ReportDetailsHelper.incidentActionProgressApi(
        context: event.context,
        incidentId: incidentId.toString(),
        incidentTypeId: incidentTypeId.toString(),
        incidentActionId: event.incidentActionId,
        status: event.actionStatus,
        row: event.row,
      );
      if(res != null){
        print(res.data!.response);
        await _fetchIncidentTypeActionApi(context: event.context, incidentTypeId: incidentTypeId,incidentId: incidentId);
          Utils.successSnackBar(msg: "Successful update", context: event.context);
        isBtnLoader = false;
        _eventCompleted(emit);
      }
    }catch(e){
      isBtnLoader = false;
      _eventCompleted(emit);
    }
}

  _eventCompleted(Emitter<ReportDetailsState> emit) {
    emit(FetchReportDetailsDataState(
      isLoader: isLoader,
      isBtnLoader: isBtnLoader,
      currentActionStatus: currentActionStatus,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
      incidentActionModel : incidentActionModel,
      listOfIncidentAction : listOfIncidentAction,
      incidentTypeActionModel : incidentTypeActionModel,
      listOfIncidentTypeAction : listOfIncidentTypeAction,
    ));
  }
}
