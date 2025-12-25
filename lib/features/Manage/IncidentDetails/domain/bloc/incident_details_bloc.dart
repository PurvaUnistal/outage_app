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
import 'package:outage_app/features/Report/ReportOutage/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/incident_report_helper.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/report_marker_polyline.dart';
import '../model/IncidentActionModel.dart';

class IncidentDetailBloc
    extends Bloc<IncidentDetailEvent, IncidentDetailState> {
  IncidentDetailBloc() : super(IncidentDetailInitialState()) {
    on<IncidentDetailLoadEvent>(_pageLoad);
    on<IncidentDetailBlinkValveMarker>(_blinkValveMarker);
    on<IncidentDetailBlinkConsumerMarker>(_blinkConsumerMarker);
    on<IncidentDetailOnCameraIdleEvent>(_onCameraIdleEvent);
    on<SubmitBtnEvent>(_submitBtnEvent);
    on<StopTimerEvent>(_stopTimer);
  }

  @override
  Future<void> close() {
    blinkTimer.cancel();
    return super.close();
  }

  void _restartBlinking() {
    if (blinkTimer.isActive == true) {
      blinkTimer.cancel();
    }
    isBlinkMarker = true;
    _startBlinking();
  }

  FutureOr<void> _stopTimer(
      StopTimerEvent event, emit,
      ) {
    if (blinkTimer.isActive) {
      blinkTimer.cancel();
    }
  }


  _startBlinking() {
    blinkTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (isBlinkMarker) {
        markersPointList.addAll(consumerMarkers);
        markersPointList.addAll(valveMarkers);
      } else {
        markersPointList.removeAll(consumerMarkers);
        markersPointList.removeAll(valveMarkers);
      }
      isBlinkMarker = !isBlinkMarker;
      emit(IncidentDetailPageLoadState());
      emit(
        FetchIncidentDetailDataState(
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
        ),
      );
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
  List<String> listOfDiaColor = [];


  bool isBlinkMarker = true;
  Timer blinkTimer = Timer(Duration.zero, () {});
  Completer<GoogleMapController> googleMapController = Completer();

  _pageLoad(IncidentDetailLoadEvent event, emit) async {
    emit(IncidentDetailInitialState());
    isLoader = false;
    isBtnLoader = false;
    isBlinkMarker = isBlinkMarker;
    blinkTimer = Timer(Duration.zero, () {});
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
    listOfDiaColor = [];

    incidentTypeId = await AppConfig.instanceInit()?.viewIncidentData.incidentTypeId ?? "";
    incidentId = await AppConfig.instanceInit()?.viewIncidentData.incid ?? "";
    print("incidentTypeId-->${incidentTypeId}");
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    var res = await IncidentReportHelper.getDiaColorApi(context: event.context);
    if (res != null) {
      listOfDiaColor = res;
    }


    await _fetchIncidentTypeActionApi(
      context: event.context,
      incidentTypeId: incidentTypeId,
      incidentId: incidentId,
    );
    await _fetchValveConsumerAffectApi(
      context: event.context,
      incidentId: incidentId,
    );
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: incidentLocation, zoom: 20),
      ),
    );

    await _filerPipe(context: event.context, emit: emit);
    _eventCompleted(emit);
  }
  _filerPipe({required BuildContext context, emit}) async {
    final pipelineBox = HiveDataBase.pipelineDataBox;

    if (pipelineBox == null || pipelineBox.values.isEmpty) {
      var res = await IncidentReportHelper.getPipelineApi(
        context: context,
        latitude: AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
        longitude: AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
      );
      if (res != null && res.data != null && res.data!.isNotEmpty) {
        listOfPipeline = res.data!;
      }
    } else {
      listOfPipeline = pipelineBox.values.toList();
    }

    if (listOfPipeline.isNotEmpty) {
      finalPolyline.clear();
      _eventCompleted(emit);
      for (int i = 0; i < listOfPipeline.length; i++) {
        pipelineData = listOfPipeline[i];
        if (pipelineData.geomencode != null &&
            pipelineData.geomencode!.isNotEmpty) {
          try {
            points = await DecodePolyline.decodePolyline(
              pipelineData.geomencode!,
            );
            final color = ReportMarkerPolyline.getPolylineColor(
              value: int.tryParse(pipelineData.nominaldia ?? '0') ?? 0,
              color: listOfDiaColor,
            );
            Set<Polyline> polyline = ReportMarkerPolyline.polylinePoint(
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
      await _filterVisiblePolyline();
      await _gotoInitialPosition(points[0]);
    }
  }

  _gotoInitialPosition(LatLng location) async {
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
    polylinePointList = {
      ...pipePolylinePointList,
      ...filterPolyline,
    };
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
    if (res != null) {
      consumerAffectModel = res;
      final incidentData = AppConfig.instanceInit()?.viewIncidentData;
      if (consumerAffectModel.data != null) {
        consumerData = consumerAffectModel.data!;
        incidentLocation = IncidentDetailHelper.parseLatLng(consumerData.latitude, consumerData.longitude,)!;
        Set<Marker> tempMarker = {};
        var incidentMarker = await NavigateAlertHelper.markerIncident(
          position: [incidentLocation],
          context: context,
          icon: BitmapDescriptor.defaultMarker,
          onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IncidentDetailHelper.row(
                          title: "Incident Priority",
                          subtitle: incidentData?.incidentpriority ?? 'N/A'
                        ),
                        IncidentDetailHelper.row(
                            title: "Incident Type",
                            subtitle: incidentData?.incidenttype ?? 'N/A'
                        ),
                        IncidentDetailHelper.row(
                            title: "Incident Status",
                            subtitle: incidentData?.actionStatus!.name.toUpperCase() ?? 'N/A'
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          "Close",
                          style: TextStyle(fontSize: 15, color: Colors.blue.shade800),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              ),
        );
        tempMarker.addAll(incidentMarker);
        markersPointList.addAll(tempMarker);
        print("markersPointList-->${markersPointList.length}");
        if (consumerData.consumer != null && consumerData.consumer!.isNotEmpty) {
          listOfConsumer = consumerData.consumer!;
          listOfConsumerPoint = _getConLatLngList(listOfConsumer);
          await _handleConsumerMarkers(
            context: context,
            listOfConsumer: listOfConsumerPoint,
          );
        }
        if (consumerData.valve != null && consumerData.valve!.isNotEmpty) {
          listOfValve = consumerData.valve!;
          listOfValvePoint = _getValveLatLngList(listOfValve);
          await _handleValveMarkers(
            context: context,
            listOfValve: listOfValvePoint,
          );
        }
        _restartBlinking();
      }
      return res;
    }
    } catch (e) {
      print("Error in _fetchValveConsumerAffectApi: $e");
    }
  }

  Future<void> _handleConsumerMarkers({
    required BuildContext context,
    required List<LatLng> listOfConsumer,
  }) async {
    final BitmapDescriptor iconBytes = await ReportMarkerPolyline.markerAsset(
      path:AssetPath.consumerBlink,
    );
    consumerMarkers = await NavigateAlertHelper.markerIncident(
      position: listOfConsumer,
      context: context,
      icon: iconBytes,
    );
    markersPointList.addAll(consumerMarkers);
  }

  Future<void> _handleValveMarkers({
    required BuildContext context,
    required List<LatLng> listOfValve,
  }) async {
    final BitmapDescriptor iconBytes = await ReportMarkerPolyline.markerAsset(
      path:AssetPath.valveBlink,
    );

    valveMarkers = await NavigateAlertHelper.markerIncident(
      position: listOfValve,
      context: context,
      icon: iconBytes,
    );
    markersPointList.addAll(valveMarkers);
  }


  List<LatLng> _getConLatLngList(List<ConsumerBPList> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map(
          (data) => LatLng(
            double.parse(data.latitude!),
            double.parse(data.longitude!),
          ),
        )
        .toList();
  }

  List<LatLng> _getValveLatLngList(List<ValveData> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map(
          (data) => LatLng(
            double.parse(data.longitude!),
            double.parse(data.latitude!),
          ),
        )
        .toList();
  }

  _blinkValveMarker(IncidentDetailBlinkValveMarker event, emit) async {
    try {
    final controller = await googleMapController.future;
    LatLng latLng = LatLng(
      double.parse(event.valveData.longitude!),
      double.parse(event.valveData.latitude!),
    );
    print("_blinkValveMarker------------------->${latLng}");

      await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    } catch (e) {
      debugPrint("Camera animation failed: $e");
    }

    _eventCompleted(emit);
  }

  _blinkConsumerMarker(IncidentDetailBlinkConsumerMarker event, emit) async {
    try {
    final controller = await googleMapController.future;
    LatLng latLng = LatLng(
      double.parse(event.consumerBPList.latitude!),
      double.parse(event.consumerBPList.longitude!),
    );
    print("_blinkConsumerMarker------------------->${latLng}");

      await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    } catch (e) {
      debugPrint("Camera animation failed: $e");
    }
    _eventCompleted(emit);
  }

  _onCameraIdleEvent(IncidentDetailOnCameraIdleEvent event, emit) async {
    await IncidentReportHelper.clearCache();
    await _filterVisiblePolyline();
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
          incidentId: incidentId,
        );
        Utils.successSnackBar(msg: "Successful update",context: event.context);
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
    emit(
      FetchIncidentDetailDataState(
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
      ),
    );
  }
}
