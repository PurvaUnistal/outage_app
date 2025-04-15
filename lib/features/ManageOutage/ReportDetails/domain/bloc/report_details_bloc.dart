import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_event.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/consumer_affect_model.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/helper/report_details_helper.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/helper/navigate_alert_helper.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import '../model/IncidentActionModel.dart';

class ReportDetailsBloc extends Bloc<ReportDetailsEvent, ReportDetailsState> {
  ReportDetailsBloc() : super(ReportDetailsInitialState()) {
    on<ReportDetailsLoadEvent>(_pageLoad);
    on<ReportDetailBlinkValveMarker>(_blinkValveMarker);
    on<ReportDetailBlinkConsumerMarker>(_blinkConsumerMarker);
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
        baseUrl: baseUrl,
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
  String role = '';
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

    incidentTypeId = await AppConfig.instanceInit()?.incidentTypeId ?? "";
    incidentId = await AppConfig.instanceInit()?.incidentId ?? "";
    print("incidentTypeId-->${incidentTypeId}");
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await _fetchIncidentTypeActionApi(
        context: event.context,
        incidentTypeId: incidentTypeId,
        incidentId: incidentId);
    await _fetchValveConsumerAffectApi(
      context: event.context,
      incidentId: incidentId,
    );
     GoogleMapController controller = await googleMapController.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: incidentLocation, zoom: 18),
            ),
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
      if(res != null){
        consumerAffectModel = res;
        if (consumerAffectModel.data != null) {
          consumerData = consumerAffectModel.data!;
          incidentLocation = ReportDetailsHelper.parseLatLng(
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
          if (consumerData.consumer?.isNotEmpty) {
            listOfConsumer = consumerData.consumer;
            listOfConsumerPoint = _getConLatLngList(listOfConsumer);
            await _handleConsumerMarkers(context: context,listOfConsumer: listOfConsumerPoint);
          }
          if (consumerData.valve?.isNotEmpty) {
              listOfValve = consumerData.valve;
              listOfValvePoint = _getLatLngList(listOfValve);
              await _handleValveMarkers(context: context,listOfValve: listOfValvePoint);
          }
          _restartBlinking();
        }
        return res;
      }

    } catch (e) {
      print("Error in _fetchValveConsumerAffectApi: $e");
    }
  }

  Future<void> _handleConsumerMarkers({required BuildContext context, required List<LatLng> listOfConsumer}) async {
    final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(AssetPath.consumerBlink, 30);
    consumerMarkers = await NavigateAlertHelper.createMarker(
      latlngList: listOfConsumer,
      context: context,
      markerIcon: BitmapDescriptor.fromBytes(iconBytes!),
    );
    markersPointList.addAll(consumerMarkers);
  }

  Future<void> _handleValveMarkers({required BuildContext context, required List<LatLng> listOfValve}) async {
    final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(AssetPath.valveBlink, 30);
    valveMarkers = await NavigateAlertHelper.createMarker(
      latlngList: listOfValve,
      context: context,
      markerIcon: BitmapDescriptor.bytes(iconBytes!),
    );
    markersPointList.addAll(valveMarkers);
  }




  void _restartBlinking() {
    if (timer.isActive == true) {
      timer.cancel();
    }
    _startBlinking();
  }


  List<LatLng> _getConLatLngList(List<ConsumerBPList> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
            LatLng(double.parse(data.latitude!), double.parse(data.longitude!)))
        .toList();
  }

  List<LatLng> _getLatLngList(List<ValveData>  dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
            LatLng(double.parse(data.longitude!), double.parse(data.latitude!)))
        .toList();
  }

  _blinkValveMarker(ReportDetailBlinkValveMarker event,  emit) async {
    LatLng latLng = LatLng(double.parse(event.valveData.longitude!), double.parse(event.valveData.latitude!));
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18),
      ),
    );
    _eventCompleted(emit);
  }

  _blinkConsumerMarker(ReportDetailBlinkConsumerMarker event,  emit) async {
    LatLng latLng = LatLng(double.parse(event.consumerBPList.latitude!), double.parse(event.consumerBPList.longitude!));
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18),
      ),
    );
    _eventCompleted(emit);
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
      baseUrl: baseUrl,
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
