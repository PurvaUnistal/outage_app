import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_event.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_state.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/consumer_affect_model.dart';
import 'package:outage_app/features/Manage/IncidentDetails/helper/incident_details_helper.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/helper/navigate_alert_helper.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/report_alert_helper.dart';
import '../model/IncidentActionModel.dart';

class IncidentDetailBloc extends Bloc<IncidentDetailEvent, IncidentDetailState> {
  IncidentDetailBloc() : super(IncidentDetailInitialState()) {
    on<IncidentDetailLoadEvent>(_pageLoad);
    on<IncidentDetailBlinkValveMarker>(_blinkValveMarker);
    on<IncidentDetailBlinkConsumerMarker>(_blinkConsumerMarker);
    on<IncidentDetailOnCameraIdleEvent>(_onCameraIdleEvent);
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
      emit(IncidentDetailPageLoadState());
      emit(FetchIncidentDetailDataState(
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



  PipelineModel pipelineModel = PipelineModel();
  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];


  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> filterPolyline = {};
  Set<Polyline> finalPolyline = {};
  List<LatLng> points = [];

  bool isBlinkMarker = true;
  Timer timer = Timer(Duration.zero, () {});
  Completer<GoogleMapController> googleMapController = Completer();

  _pageLoad(IncidentDetailLoadEvent event, emit) async {
    emit(IncidentDetailInitialState());
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

    await _fetchGasPipelineGisApi(context: event.context, emit: emit);
    _eventCompleted(emit);
  }

  _fetchGasPipelineGisApi({required BuildContext context, emit}) async {
    if (await HiveDataBase.pipelineDataBox!.values.isEmpty) {
      var res = await ReportAlertHelper.getPipelineApi(
        context: context,
        latitude: AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
        longitude: AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
      );
      if(res != null && res.data != null){
        listOfPipeline = res.data!;
      }
    } else {
      listOfPipeline = await HiveDataBase.pipelineDataBox!.values.toList();
    }
    if (listOfPipeline.isNotEmpty) {
      finalPolyline.clear();
      _eventCompleted(emit);
      for (int i = 0; i < listOfPipeline.length; i++) {
        final data = listOfPipeline[i];
        if (data.geomencode != null && data.geomencode!.isNotEmpty) {
          try {
            points = await DecodePolyline.decodePolyline(data.geomencode!);
            final color = ReportAlertHelper.getPolylineColor(
              int.tryParse(data.nominaldia ?? '0') ?? 0,
            );
            Set<Polyline> polyline = ReportAlertHelper.polylinePoint(
              i: i,
              color: color,
              position: points,
              context: context,
            );
            finalPolyline.addAll(polyline);
          } catch (e) {
            print("Error decoding polyline at index $i: $e");
          }
        }
      }
      await gotoInitialPosition(points[0]);
      _filterVisiblePolyline();
      _eventCompleted(emit);
    }
  }

  gotoInitialPosition(LatLng location) async {
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: incidentLocation, zoom: 18),
      ),
    );
  }


  Future<void> _filterVisiblePolyline() async {
    final controller = await googleMapController.future;
    final bounds = await controller.getVisibleRegion();
    pipePolylinePointList =
        finalPolyline.where((polyline) {
          return polyline.points.any(
                (point) => DecodePolyline.isPointInBounds(point, bounds),
          );
        }).toSet();

    _updateMarkerPolyline();
  }

  _updateMarkerPolyline() {
    polylinePointList = {...pipePolylinePointList, ...filterPolyline};
    print("pipePolylinePointList-->${pipePolylinePointList.length}");
    print("filterPolyline-->${filterPolyline.length}");
  }

  _fetchIncidentTypeActionApi({
    required BuildContext context,
    required String incidentTypeId,
    required String incidentId,
  }) async {
    var res = await IncidentDetailHelper.getIncidentTypeActionApi(
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
      var res = await IncidentDetailHelper.getValveConsumerAffectApi(
        context: context,
        incidentId: incidentId,
      );
      if(res != null){
        consumerAffectModel = res;
        if (consumerAffectModel.data != null) {
          consumerData = consumerAffectModel.data!;
          incidentLocation = IncidentDetailHelper.parseLatLng(
            consumerData.latitude,
            consumerData.longitude,
          )!;
          Set<Marker> tempMarker = {};
          var incidentMarker = await NavigateAlertHelper.markerIncident(
            position: [incidentLocation],
            context: context,
            icon: BitmapDescriptor.defaultMarker,

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
    final BitmapDescriptor  iconBytes = await ReportAlertHelper.markerAsset(AssetPath.consumerBlink);
    consumerMarkers = await NavigateAlertHelper.markerIncident(
      position: listOfConsumer,
      context: context,
      icon: iconBytes,
    );
    markersPointList.addAll(consumerMarkers);
  }

  Future<void> _handleValveMarkers({required BuildContext context, required List<LatLng> listOfValve}) async {
    final BitmapDescriptor  iconBytes = await ReportAlertHelper.markerAsset(AssetPath.valveBlink);
    valveMarkers = await NavigateAlertHelper.markerIncident(
      position: listOfValve,
      context: context,
      icon: iconBytes,
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

  _blinkValveMarker(IncidentDetailBlinkValveMarker event,  emit) async {
    LatLng latLng = LatLng(double.parse(event.valveData.longitude!), double.parse(event.valveData.latitude!));
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18),
      ),
    );
    _eventCompleted(emit);
  }

  _blinkConsumerMarker(IncidentDetailBlinkConsumerMarker event,  emit) async {
    LatLng latLng = LatLng(double.parse(event.consumerBPList.latitude!), double.parse(event.consumerBPList.longitude!));
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18),
      ),
    );
    _eventCompleted(emit);
  }

  _onCameraIdleEvent(IncidentDetailOnCameraIdleEvent event, emit) async {
    await ReportAlertHelper.clearCache();
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _submitBtnEvent(SubmitBtnEvent event, emit) async {
    try {
      isBtnLoader = true;
      currentActionStatus = event.actionStatus;
      _eventCompleted(emit);
      var res = await IncidentDetailHelper.incidentActionProgressApi(
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

  _eventCompleted(Emitter<IncidentDetailState> emit) {
    emit(FetchIncidentDetailDataState(
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
      polylinePointList: Set.of(polylinePointList),
      incidentActionModel: incidentActionModel,
      listOfIncidentAction: listOfIncidentAction,
      incidentTypeActionModel: incidentTypeActionModel,
      listOfIncidentTypeAction: listOfIncidentTypeAction,
    ));
  }
}
