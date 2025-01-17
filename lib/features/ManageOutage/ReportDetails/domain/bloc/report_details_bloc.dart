import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_event.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/model/consumer_affect_model.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/helper/report_details_helper.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/helper/navigate_alert_helper.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import '../model/IncidentActionModel.dart';

class ReportDetailsBloc extends Bloc<ReportDetailsEvent, ReportDetailsState> {
  ReportDetailsBloc() : super(ReportDetailsInitialState()) {
    on<ReportDetailsLoadEvent>(_pageLoad);
    on<SubmitBtnEvent>(_submitBtnEvent);
  }


  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }

  _startBlinking() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if(isBlinkMarker) {
        markersPointList.addAll(consumerMarkers);
        markersPointList.addAll(valveMarkers);
      } else {
        markersPointList.removeAll(consumerMarkers);
        markersPointList.removeAll(valveMarkers);
      }
      isBlinkMarker = !isBlinkMarker;
      emit(ReportDetailsPageLoadState());
      emit(FetchReportDetailsDataState(
        isLoader: isLoader,
        isBtnLoader: isBtnLoader,
        currentActionStatus: currentActionStatus,
        scheme: scheme,
        baseUrl: baseUrl,
        userName: userName,
        role: role,
        incidentLocation: incidentLocation,
        consumerAffectMode: consumerAffectModel,
        consumerData: consumerData,
        listOfValve: listOfValve,
        listOfConsumer: listOfConsumer,
        markersPointList: markersPointList,
        googleMapController: googleMapController,
        polylinePointList: polylinePointList,
        incidentActionModel: incidentActionModel,
        listOfIncidentAction: listOfIncidentAction,
        incidentTypeActionModel: incidentTypeActionModel,
        listOfIncidentTypeAction: listOfIncidentTypeAction,
      ));
    });
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
  LatLng incidentLocation = LatLng(0, 0);

  IncidentActionModel incidentActionModel = IncidentActionModel();
  List<IncidentActionData> listOfIncidentAction = [];

  IncidentTypeActionModel incidentTypeActionModel = IncidentTypeActionModel();
  List<IncidentTypeAction> listOfIncidentTypeAction = [];

  ConsumerAffectModel consumerAffectModel = ConsumerAffectModel();
  ConsumerData consumerData = ConsumerData();
  ValveData valveData = ValveData();
  List<ValveData> listOfValve = [];
  List<ConsumerBPList> listOfConsumer = [];
  List<LatLng> listOfConsumerPoint = [];
  List<LatLng> listOfValvePoint = [];

  Set<Marker> markersPointList = {};
  Set<Marker> consumerMarkers = {};
  Set<Marker> valveMarkers = {};
  Set<Marker> conMarkerPointList = {};
  Set<Marker> valveMarkerPointList = {};
  Set<Polyline> polylinePointList = {};
  bool isBlinkMarker = true;
  Timer timer = Timer(Duration.zero, () {});
  Completer<GoogleMapController> googleMapController = Completer();

  _pageLoad(ReportDetailsLoadEvent event, emit) async {
    emit(ReportDetailsInitialState());
    isLoader = false;
    isBtnLoader = false;
    isBlinkMarker = isBlinkMarker;
    incidentLocation = LatLng(0, 0);
    timer = Timer(Duration.zero, () {});
    googleMapController = Completer();
    listOfConsumerPoint = [];
    listOfValvePoint = [];
    incidentActionModel = IncidentActionModel();
    listOfIncidentAction = [];

    incidentTypeActionModel = IncidentTypeActionModel();
    listOfIncidentTypeAction = [];

    consumerAffectModel = ConsumerAffectModel();
    consumerData = ConsumerData();
    valveData = ValveData();
    listOfValve = [];
    listOfConsumer = [];

    markersPointList = {};
    conMarkerPointList = {};
    valveMarkerPointList = {};
    polylinePointList = {};

    incidentTypeId = await SharedPref.getString(key: PrefsValue.incidentTypeId);
    incidentId = await SharedPref.getString(key: PrefsValue.incidentId);
    print("incidentTypeId-->${incidentTypeId}");
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await _fetchIncidentTypeActionApi(
        context: event.context,
        incidentTypeId: incidentTypeId,
        incidentId: incidentId);
    await _fetchValveConsumerAffectApi(
      context: event.context,
      incidentId: incidentId,
    );
    _eventCompleted(emit);
  }

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
        listOfIncidentTypeAction = incidentTypeActionModel.data!;
        for (var data in listOfIncidentTypeAction) {
          if (data.actionStatus == "1") {
            break;
          } else if (data.actionStatus == null) {
            data.actionStatusEnable = true;
            break;
          } else {}
        }
      }
      return res;
    }
  }

  _fetchValveConsumerAffectApi({
    required BuildContext context,
    required String incidentId,
  }) async {
    try {
      var res = await ReportDetailsHelper.getValveConsumerAffectApi(
        context: context,
        incidentId: incidentId,
      );
      if (res == null) throw Exception("No data returned");
      consumerAffectModel = res;
      if (consumerAffectModel.data != null) {
        consumerData = consumerAffectModel.data!;
        incidentLocation = _parseLatLng(
          consumerData.latitude,
          consumerData.longitude,
        )!;
        Set<Marker> tempMarker = {};
        var incidentMarker = await NavigateAlertHelper.createMarker(
          latlngList: [incidentLocation],
          context: context,
          markerIcon: BitmapDescriptor.defaultMarker,
        );
        tempMarker.addAll(incidentMarker);
        markersPointList.addAll(tempMarker);
        print("markersPointList-->${markersPointList.length}");
        if (consumerData.consumer?.isNotEmpty == true) {
          listOfConsumer = consumerData.consumer;
          listOfConsumerPoint = _getConLatLngList(consumerData.consumer!);
          await _handleConsumerMarkers(context: context);
          _restartBlinking();
        }
        if (consumerData.valve?.isNotEmpty == true) {
          listOfValve = consumerData.valve[0];
          listOfValvePoint = _getLatLngList(consumerData.valve![0]);
          await _handleValveMarkers(context: context);
        }
      }
      return res;
    } catch (e) {
      print("Error in _fetchValveConsumerAffectApi: $e");
    }
  }

  Future<void> _handleConsumerMarkers({required BuildContext context}) async {
    final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(AssetPath.consumer, 80);
    consumerMarkers = await NavigateAlertHelper.createMarker(
      latlngList: listOfConsumerPoint,
      context: context,
      markerIcon: BitmapDescriptor.fromBytes(iconBytes!),
    );
    markersPointList.addAll(consumerMarkers);
  }

  Future<void> _handleValveMarkers({required BuildContext context}) async {
    final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(AssetPath.valve, 80);
    valveMarkers = await NavigateAlertHelper.createMarker(
      latlngList: listOfValvePoint,
      context: context,
      markerIcon: BitmapDescriptor.fromBytes(iconBytes!),
    );
    markersPointList.addAll(valveMarkers);
  }




  void _restartBlinking() {
    if (timer.isActive == true) {
      timer.cancel();
    }
    _startBlinking();
  }

  LatLng? _parseLatLng(String? lat, String? lng) {
    double? latitude = double.tryParse(lat ?? '');
    double? longitude = double.tryParse(lng ?? '');
    return (latitude != null && longitude != null)
        ? LatLng(latitude, longitude)
        : null;
  }

  List<LatLng> _getConLatLngList(List<dynamic> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
            LatLng(double.parse(data.latitude!), double.parse(data.longitude!)))
        .toList();
  }

  List<LatLng> _getLatLngList(List<dynamic> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
            LatLng(double.parse(data.longitude!), double.parse(data.latitude!)))
        .toList();
  }

  _submitBtnEvent(SubmitBtnEvent event, emit) async {
    try {
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
      if (res != null) {
        print(res.data!.response);
        await _fetchIncidentTypeActionApi(
            context: event.context,
            incidentTypeId: incidentTypeId,
            incidentId: incidentId);
        Utils.successSnackBar(msg: "Successful update", context: event.context);
        isBtnLoader = false;
        currentActionStatus = event.actionStatus;
        _eventCompleted(emit);
      } else {
        isBtnLoader = false;
        currentActionStatus = event.actionStatus;
        _eventCompleted(emit);
      }
    } catch (e) {
      isBtnLoader = false;
      currentActionStatus = event.actionStatus;
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
      incidentLocation: incidentLocation,
      consumerAffectMode: consumerAffectModel,
      consumerData: consumerData,
      listOfValve: listOfValve,
      listOfConsumer: listOfConsumer,
      markersPointList: markersPointList,
      googleMapController: googleMapController,
      polylinePointList: polylinePointList,
      incidentActionModel: incidentActionModel,
      listOfIncidentAction: listOfIncidentAction,
      incidentTypeActionModel: incidentTypeActionModel,
      listOfIncidentTypeAction: listOfIncidentTypeAction,
    ));
  }
}
