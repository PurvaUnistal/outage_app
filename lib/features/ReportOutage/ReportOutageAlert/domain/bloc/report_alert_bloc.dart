import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GisConfig.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/getNearestPoint.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/presentation/widget/alert_dialog_widget.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/presentation/widget/report_pop_widget.dart';
import 'report_alert_event.dart';
import 'report_alert_state.dart';

class ReportAlertBloc extends Bloc<ReportAlertEvent, ReportAlertState> {
  ReportAlertBloc() : super(ReportAlertInitialState()) {
    on<ReportAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectCurrentMarkerButtonEvent>(_selectCurrentMarkerButton);
    on<SelectGoogleMapButtonEvent>(_selectGoogleMapButton);
    on<SelectFilterButtonEvent>(_selectFilterButton);

    on<SelectCheckBoxTFGisEvent>(_selectCheckBoxTFGis);
    on<SelectTFGisEvent>(_selectTFGisValue);

    on<SelectCheckBoxValveGisEvent>(_selectCheckBoxValveGis);
    on<SelectValveGISValueEvent>(_selectValveGISValue);

    on<SelectCheckBoxRegulatorGisEvent>(_selectCheckBoxRegulatorGis);
    on<SelectRegulatorGISValueEvent>(_selectRegulatorGISValue);

    on<SelectCheckBoxTeeGisEvent>(_selectCheckBoxTeeGis);
    on<SelectTeeGISValueEvent>(_selectTeeGISValue);

    on<SelectCheckBoxElbowGisEvent>(_selectCheckBoxElbowGis);
    on<SelectElbowGISValueEvent>(_selectElbowGISValue);

    on<SelectCheckBoxCouplerGisEvent>(_selectCheckBoxCouplerGis);
    on<SelectCouplerGISValueEvent>(_selectCouplerGISValue);

    on<SelectCheckBoxReducerGisEvent>(_selectCheckBoxReducerGis);
    on<SelectReducerGISValueEvent>(_selectReducerGISValue);

    on<SelectCheckBoxEndCapGisEvent>(_selectCheckBoxEndCapGis);
    on<SelectEndCapGISValueEvent>(_selectEndCapGISValue);

    on<SelectCheckBoxConsumerGisEvent>(_selectCheckBoxConsumerGis);
    on<SelectConsumerGISValueEvent>(_selectConsumerGISValue);

    on<OnCameraIdleEvent>(_onCameraIdleEvent);
    on<ResetFilterEvent>(_onResetFilterEvent);
  }


  bool isLoader = false;
  bool isPipelineLoader = false;
  bool checkBoxTf = false;
  bool isGasTfLoader = false;
  bool checkBoxValve = false;
  bool isGasValveLoader = false;
  bool checkBoxRegulator = false;
  bool isGasRegulatorLoader = false;
  bool checkBoxTee = false;
  bool isGasTeeLoader = false;
  bool checkBoxElbow = false;
  bool isGasElbowLoader = false;
  bool checkBoxCoupler = false;
  bool isGasCouplerLoader = false;
  bool checkBoxReducer = false;
  bool isGasReducerLoader = false;
  bool checkBoxEndCap = false;
  bool isGasEndCapLoader = false;
  bool checkBoxConsumer = false;
  bool isGasConsumerLoader = false;

  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String loginLat = '';
  String loginLong = '';
  String nameofLocation = '';

  final TextEditingController tfGisController = TextEditingController();
  final TextEditingController gasValveGISController = TextEditingController();
  final TextEditingController gasRegulatorGISController = TextEditingController();
  final TextEditingController gasTeeGISController = TextEditingController();
  final TextEditingController gasElbowGISController = TextEditingController();
  final TextEditingController gasCouplerGISController = TextEditingController();
  final TextEditingController gasReducerGISController = TextEditingController();
  final TextEditingController gasEndCapGISController = TextEditingController();
  final TextEditingController gasConsumerGISController = TextEditingController();

  GetPipelineGisModel gasPipelineModel = GetPipelineGisModel();
  List<GetPipelineGisData> listOfPipelineGIS = [];

  GetGasValueGISModel fittingGISModel = GetGasValueGISModel();
  List<GetGasValueGISData> listOfFittingGIS = [];

  GetGasGisModel tfGisModel = GetGasGisModel();
  List<GasGisData> listOfTfGis = [];
  List<GasGisData> listOfFilterTfGis = [];
  List<String> listOfTfGisId = [];

  GetGasGisModel gasValueGISModel = GetGasGisModel();
  List<GasGisData> listOfGasValueGIS = [];
  List<GasGisData> listOfFilterGasValueGIS = [];
  List<String> listOfGasValveGISId = [];

  GetGasGisModel gasRegulatorGISModel = GetGasGisModel();
  List<GasGisData> listOfGasRegulatorGIS = [];
  List<GasGisData> listOfFilterGasRegulatorGIS = [];
  List<String> listOfGasRegulatorGISId = [];

  GetGasGisModel gasTeeGISModel = GetGasGisModel();
  List<GasGisData> listOfGasTeeGIS = [];
  List<GasGisData> listOfFilterGasTeeGIS = [];
  List<String> listOfGasTeeGISId = [];

  GetGasGisModel gasElbowGISModel = GetGasGisModel();
  List<GasGisData> listOfGasElbowGIS = [];
  List<GasGisData> listOfFilterGasElbowGIS = [];
  List<String> listOfGasElbowGISId = [];

  GetGasGisModel gasCouplerGISModel = GetGasGisModel();
  List<GasGisData> listOfGasCouplerGIS = [];
  List<GasGisData> listOfFilterGasCouplerGIS = [];
  List<String> listOfGasCouplerGISId = [];

  GetGasGisModel gasReducerGISModel = GetGasGisModel();
  List<GasGisData> listOfGasReducerGIS = [];
  List<GasGisData> listOfFilterGasReducerGIS = [];
  List<String> listOfGasReducerGISId = [];

  GetGasGisModel gasEndCapGISModel = GetGasGisModel();
  List<GasGisData> listOfGasEndCapGIS = [];
  List<GasGisData> listOfFilterGasEndCapGIS = [];
  List<String> listOfGasEndCapGISId = [];

  GetGasGisModel gasConsumerGISModel = GetGasGisModel();
  List<GasGisData> listOfGasConsumerGIS = [];
  List<GasGisData> listOfFilterConsumerGIS = [];
  List<String> listOfGasConsumerGISId = [];

  GetPipelineNetworkModel pipelineNetworkModel = GetPipelineNetworkModel();
  PipelineNetworkData pipelineNetworkData = PipelineNetworkData();
  List<PipelineNetworkData> listOfPipelineNetwork = [];

  PipelineModel pipelineModel = PipelineModel();
  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];

  Set<Polyline> finalPolylines = {};

  LatLng currentPosition = LatLng(0, 0);
  LatLng loginPosition = LatLng(0, 0);

  List<LatLng> allLatLongPoint = [];

  Set<Circle> circles = {};
  Set<Marker> markersPointList = {};
  Set<Marker> filterMarkerList = {};

  Set<Polyline> polylinePointList = {};
  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> filterPolyline = {};

  MapType currentMapType = MapType.normal;
  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: AppString.zoom,
  );
  Timer? _timer;
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  _pageLoad(ReportAlertLoadEvent event, emit) async {
    emit(ReportAlertPageLoadState());
    isLoader = false;
    _initializeAllModels();
    ReportAlertHelper.clearCache();
    await _selectGISValue(
      assetId: "",
      assetTypeId: "",
      dataList: [],
      controller: TextEditingController(),
      context: event.context,
      assetPath: "",
      filteredList: [],
    );

    await _currentPointMarker();
    await _fetchGasPipelineGisApi(context: event.context,emit: emit);
    _eventCompleted(emit);
  }

  Future<void> _initializeAllModels() async {
    isPipelineLoader = false;

    await _clearTextField();
    gasPipelineModel = GetPipelineGisModel();
    listOfPipelineGIS = [];
    gasValueGISModel = GetGasGisModel();
    listOfGasValueGIS = [];
    listOfFilterGasValueGIS = [];
    listOfGasValveGISId = [];
    fittingGISModel = GetGasValueGISModel();
    listOfFittingGIS = [];
    tfGisModel = GetGasGisModel();
    listOfTfGis = [];
    listOfFilterTfGis = [];
    listOfTfGisId = [];
    gasRegulatorGISModel = GetGasGisModel();
    listOfGasRegulatorGIS = [];
    listOfFilterGasRegulatorGIS = [];
    listOfGasRegulatorGISId = [];

    gasTeeGISModel = GetGasGisModel();
    listOfGasTeeGIS = [];
    listOfFilterGasTeeGIS = [];
    listOfGasTeeGISId = [];

    gasElbowGISModel = GetGasGisModel();
    listOfGasElbowGIS = [];
    listOfFilterGasElbowGIS = [];
    listOfGasElbowGISId = [];

    gasCouplerGISModel = GetGasGisModel();
    listOfGasCouplerGIS = [];
    listOfFilterGasCouplerGIS = [];
    listOfGasCouplerGISId = [];

    gasReducerGISModel = GetGasGisModel();
    listOfGasReducerGIS = [];
    listOfFilterGasReducerGIS = [];
    listOfGasReducerGISId = [];

    gasEndCapGISModel = GetGasGisModel();
    listOfGasEndCapGIS = [];
    listOfFilterGasEndCapGIS = [];
    listOfGasEndCapGISId = [];

    gasConsumerGISModel = GetGasGisModel();
    listOfGasConsumerGIS = [];
    listOfFilterConsumerGIS = [];
    listOfGasConsumerGISId = [];

    pipelineNetworkModel = GetPipelineNetworkModel();
    pipelineNetworkData = PipelineNetworkData();
    listOfPipelineNetwork = [];

    pipelineModel = PipelineModel();
    pipelineData = PipelineData();
    listOfPipeline = [];

    currentPosition = LatLng(0, 0);
    loginPosition = LatLng(0, 0);

    markersPointList = {};
    filterMarkerList = {};

    filterPolyline = {};
    polylinePointList = {};
    pipePolylinePointList = {};

    allLatLongPoint = [];
    googleMapController = Completer();

    currentMapType = MapType.normal;
    role = await AppConfig.instanceInit()?.loginData.user?.role??"";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    loginLat = await AppConfig.instanceInit()?.loginData.user?.gaLatitude??"";
    loginLong = await AppConfig.instanceInit()?.loginData.user?.gaLongitude??"";
    loginPosition = LatLng(
        double.parse(loginLat.toString()), double.parse(loginLong.toString()));
  }

   _startCacheClearTimer() {
    _timer = Timer.periodic(Duration(seconds: 16), (timer) async {
      log("Clearing Cache...");
      await ReportAlertHelper.clearCache();
    });
  }

  _fetchGasPipelineGisApi({required BuildContext context,emit}) async {
    var res = await ReportAlertHelper.getPipelineApi(
      context: context,
      latitude: loginPosition.latitude.toString(),
      longitude: loginPosition.longitude.toString(),
    );
    if (res != null && res.data != null) {
      pipelineModel = res;
      listOfPipeline = pipelineModel.data!;
      finalPolylines.clear();
      _eventCompleted(emit);
      await gotoInitialPosition(loginPosition);
      for (int i = 0; i < listOfPipeline.length; i++) {
        final data = listOfPipeline[i];
        if (data.geomencode != null && data.geomencode!.isNotEmpty) {
          try {
            List<LatLng> points =
            await DecodePolyline.decodePolyline(data.geomencode!);
           /* final color = ReportAlertHelper.getPolylineColor(
              int.tryParse(data.nominaldia ?? '0') ?? 0,
            );*/
            Polyline polyline = Polyline(
              polylineId: PolylineId("polyline_$i"),
              points: points,
              color: Colors.green,
              width: 4,
            );
            finalPolylines.add(polyline);
          } catch (e) {
            print("Error decoding polyline at index $i: $e");
          }
        }
      }
      _filterVisiblePolyline();
      _eventCompleted(emit);
    }
  }

  Future<void> _filterVisiblePolyline() async {
    final controller = await googleMapController.future;
    final bounds = await controller.getVisibleRegion();
    pipePolylinePointList = finalPolylines.where((polyline) {
      return polyline.points.any((point) => DecodePolyline.isPointInBounds(point, bounds));
    }).toSet();
    _updateMarkerPolyline();
  }

  Future<void> gotoInitialPosition(LatLng location) async {
    CameraPosition position = CameraPosition(
        target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  _fetchTFGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getTFGisApi(
      context: context,
    );
    if (res != null) {
      tfGisModel = res;
      if (tfGisModel.data != null) {
        listOfTfGis = tfGisModel.data!;
        listOfTfGisId = listOfTfGis.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasValueGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getGasValueGisApi(
      context: context,
    );
    if (res != null) {
      gasValueGISModel = res;
      if (gasValueGISModel.data != null) {
        listOfGasValueGIS = gasValueGISModel.data!;
        listOfGasValveGISId = listOfGasValueGIS.map((e) => e.valveId!).toList();
        return res;
      }
    }
  }

  _fetchGasRegulatorGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getRegulatorGisApi(
      context: context,
    );
    if (res != null) {
      gasRegulatorGISModel = res;
      if (gasRegulatorGISModel.data != null) {
        listOfGasRegulatorGIS = gasRegulatorGISModel.data!;
        listOfGasRegulatorGISId =
            listOfGasRegulatorGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasTeeGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getTeeGisApi(
      context: context,
    );
    if (res != null) {
      gasTeeGISModel = res;
      if (gasTeeGISModel.data != null) {
        listOfGasTeeGIS = gasTeeGISModel.data!;
        listOfGasTeeGISId = listOfGasTeeGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasElbowGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getElbowGisApi(
      context: context,
    );
    if (res != null) {
      gasElbowGISModel = res;
      if (gasElbowGISModel.data != null) {
        listOfGasElbowGIS = gasElbowGISModel.data!;
        listOfGasElbowGISId = listOfGasElbowGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasCouplerGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getCouplerGisApi(
      context: context,
    );
    if (res != null) {
      gasCouplerGISModel = res;
      if (gasCouplerGISModel.data != null) {
        listOfGasCouplerGIS = gasCouplerGISModel.data!;
        listOfGasCouplerGISId = listOfGasCouplerGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasReducerGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getReducerGisApi(
      context: context,
    );
    if (res != null) {
      gasReducerGISModel = res;
      if (gasReducerGISModel.data != null) {
        listOfGasReducerGIS = gasReducerGISModel.data!;
        listOfGasReducerGISId = listOfGasReducerGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasEndCapGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getEndCapGisApi(
      context: context,
    );
    if (res != null) {
      gasEndCapGISModel = res;
      if (gasEndCapGISModel.data != null) {
        listOfGasEndCapGIS = gasEndCapGISModel.data!;
        listOfGasEndCapGISId = listOfGasEndCapGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasConsumerGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getConsumerGisApi(
      context: context,
    );
    if (res != null) {
      gasConsumerGISModel = res;
      if (gasConsumerGISModel.data != null) {
        listOfGasConsumerGIS = gasConsumerGISModel.data!;
        listOfGasConsumerGISId =
            listOfGasConsumerGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _onResetFilterEvent(ResetFilterEvent event, emit) async {
    _clearTextField();
    _clearMarkerPolyline();
    GoogleMapController controller = await googleMapController.future;
    currentPosition = LatLng(loginPosition.latitude, loginPosition.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: 14)));
    Navigator.pop(event.context, true);
    _eventCompleted(emit);
  }

  _onCameraIdleEvent(OnCameraIdleEvent event, emit) async {
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }


  Future<void> _fetchPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    await _clearMarkerPolyline();
    try {
      var res = await ReportAlertHelper.getPipelineNetworkApi(
        context: context,
        latitude: latitude,
        longitude: longitude,
      );
      if (res != null) {
        pipelineNetworkModel = res;
        if (pipelineNetworkModel.data?.isNotEmpty ?? false) {
          listOfPipelineNetwork = pipelineNetworkModel.data!;
          var gisConfig = await _getActiveGisConfig();
          if (gisConfig == null) {
            Utils.errorSnackBar(
                msg: "GIS configuration is missing.", context: context);
            return;
          }
          for (var pipeline in listOfPipelineNetwork) {
            if (pipeline.geomencode != null) {
              List<LatLng> filterLatLngGis =
                  await DecodePolyline.decodePolyline(pipeline.geomencode!);
              var polylines = await ReportAlertHelper.createPolyLine(
                color: gisConfig.polylineColor,
                latlngList: filterLatLngGis,
                context: context,
              );
              gisConfig.polylineList?.addAll(polylines);
              filterPolyline.addAll(polylines);
            }
          }
          _updateMarkerPolyline();
        } else {
          Utils.errorSnackBar(
              msg: "No pipeline data available.", context: context);
        }
      } else {
        Utils.errorSnackBar(
            msg: "Failed to fetch pipeline network data.", context: context);
      }
    } catch (e) {
      Utils.errorSnackBar(
          msg: "An error occurred: ${e.toString()}", context: context);
    }
  }

  Future<GisConfig?> _getActiveGisConfig() async {
    if (tfGisController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.tf,
        polylineColor: Colors.yellow.shade900,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasValveGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.valve,
        polylineColor: Colors.deepOrange,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasRegulatorGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.regulator,
        polylineColor: Colors.yellowAccent.shade700,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasTeeGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.tee,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasElbowGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.elbow,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasCouplerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.coupler,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasReducerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.reduce,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasEndCapGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.endcap,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasConsumerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.consumer,
        polylineColor: Colors.green,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    }
    if (filterMarkerList.isNotEmpty) {
      GoogleMapController controller = await googleMapController.future;
      currentPosition = LatLng(
        filterMarkerList.first.position.latitude,
        filterMarkerList.first.position.longitude,
      );
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 16),
        ),
      );
    }
    return null;
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _selectCurrentMarkerButton(SelectCurrentMarkerButtonEvent event, emit) async {
    await _currentPointMarker();
    _eventCompleted(emit);
  }

  _currentPointMarker() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    if (currentPoint != null) {
      currentPosition = LatLng(currentPoint.latitude, currentPoint.longitude);
      cameraPosition = CameraPosition(target: currentPosition, zoom: 14);
    }
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTf = event.checkBoxTf;
    if (checkBoxTf == true) {
      isGasTfLoader = true;
      _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context);
    }
    isGasTfLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxValve = event.checkBoxValve;
    if (checkBoxValve == true) {
      isGasValveLoader = true;
      _eventCompleted(emit);
      await _fetchGasValueGisApi(context: event.context);
    }
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxRegulatorGis(
      SelectCheckBoxRegulatorGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxRegulator = event.checkBoxRegulator;
    if (checkBoxRegulator == true) {
      isGasRegulatorLoader = true;
      _eventCompleted(emit);
      await _fetchGasRegulatorGisApi(context: event.context);
    }
    isGasRegulatorLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxTeeGis(SelectCheckBoxTeeGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTee = event.checkBoxTee;
    if (checkBoxTee == true) {
      isGasTeeLoader = true;
      _eventCompleted(emit);
      await _fetchGasTeeGisApi(context: event.context);
    }
    isGasTeeLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxElbowGis(SelectCheckBoxElbowGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxElbow = event.checkBoxElbow;
    if (checkBoxElbow == true) {
      isGasElbowLoader = true;
      _eventCompleted(emit);
      await _fetchGasElbowGisApi(context: event.context);
    }
    isGasElbowLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxCouplerGis(SelectCheckBoxCouplerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxCoupler = event.checkBoxCoupler;
    if (checkBoxCoupler == true) {
      isGasCouplerLoader = true;
      _eventCompleted(emit);
      await _fetchGasCouplerGisApi(context: event.context);
    }
    isGasCouplerLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxReducerGis(SelectCheckBoxReducerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxReducer = event.checkBoxReducer;
    if (checkBoxReducer == true) {
      isGasReducerLoader = true;
      _eventCompleted(emit);
      await _fetchGasReducerGisApi(context: event.context);
    }
    isGasReducerLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxEndCapGis(SelectCheckBoxEndCapGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxEndCap = event.checkBoxEndCap;
    if (checkBoxEndCap == true) {
      isGasEndCapLoader = true;
      _eventCompleted(emit);
      await _fetchGasEndCapGisApi(context: event.context);
    }
    isGasEndCapLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxConsumerGis(SelectCheckBoxConsumerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxConsumer = event.checkBoxConsumer;
    if (checkBoxConsumer == true) {
      isGasConsumerLoader = true;
      _eventCompleted(emit);
      await _fetchGasConsumerGisApi(context: event.context);
    }
    isGasConsumerLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _selectGISValue({
    required String assetId,
    required String assetTypeId,
    required List dataList,
    required TextEditingController controller,
    required BuildContext context,
    required String assetPath,
    required List filteredList,
  }) async {
    filteredList.clear();
    assetId == '';
    assetTypeId == '';
    _clearMarkerPolyline();
    controller.text = assetTypeId;
    Set<Marker> tempMarker = {};
    if (controller.text.isNotEmpty) {
      filteredList.addAll(dataList.where((data) {
        if (gasValveGISController.text.isNotEmpty) {
          return data.valveId.toString() == assetTypeId;
        } else {
          return data.toString() == assetTypeId;
        }
      }).toList());
      if (filteredList.isNotEmpty) {
        final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(assetPath, 80);
        LatLng location = LatLng(
          double.parse(filteredList[0].latitude!),
          double.parse(filteredList[0].longitude!),
        );
        AppConfig.instanceInit()?.setAssets(assets: assetId);
        AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: assetTypeId);
        var markers = await ReportAlertHelper.createMarker(
          latlngList: [location],
          context: context,
          markerIcon: BitmapDescriptor.fromBytes(iconBytes!),
        );
        await _fetchPipelineNetworkApi(
          context: context,
          latitude: location.latitude.toString(),
          longitude: location.longitude.toString(),
        );
        tempMarker.addAll(markers);
        currentPosition = LatLng(location.latitude, location.longitude);
        cameraPosition = CameraPosition(target: currentPosition, zoom: 16);
        markersPointList = tempMarker;
        if (tempMarker.isNotEmpty) {
          GoogleMapController controller = await googleMapController.future;
          currentPosition = LatLng(
            tempMarker.first.position.latitude,
            tempMarker.first.position.longitude,
          );
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: currentPosition, zoom: 16),
            ),
          );
        }
      }
    } else {
      AppConfig.instanceInit()?.setAssets(assets: '');
      AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: '');
    }
  }

  Future<void> _selectTFGisValue(SelectTFGisEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: tfGisModel.assetId!,
      assetTypeId: event.tfGisId,
      dataList: listOfTfGis,
      controller: tfGisController,
      context: event.context,
      assetPath: AssetPath.tf,
      filteredList: listOfFilterTfGis,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _selectValveGISValue(
      SelectValveGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasValueGISModel.assetId ?? "",
      assetTypeId: event.gasValveGISId,
      dataList: listOfGasValueGIS,
      controller: gasValveGISController,
      context: event.context,
      assetPath: AssetPath.valve,
      filteredList: listOfFilterGasValueGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _selectRegulatorGISValue(
      SelectRegulatorGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasRegulatorGISModel.assetId ?? "",
      assetTypeId: event.gasRegulatorGISId,
      dataList: listOfGasRegulatorGIS,
      controller: gasRegulatorGISController,
      context: event.context,
      assetPath: AssetPath.regulator,
      filteredList: listOfFilterGasRegulatorGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectTeeGISValue(SelectTeeGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasTeeGISModel.assetId!,
      assetTypeId: event.gasTeeGISId,
      dataList: listOfGasTeeGIS,
      controller: gasTeeGISController,
      context: event.context,
      assetPath: AssetPath.tee,
      filteredList: listOfFilterGasTeeGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectElbowGISValue(SelectElbowGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasElbowGISModel.assetId!,
      assetTypeId: event.gasElbowGISId,
      dataList: listOfGasElbowGIS,
      controller: gasElbowGISController,
      context: event.context,
      assetPath: AssetPath.elbow,
      filteredList: listOfFilterGasElbowGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCouplerGISValue(SelectCouplerGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasCouplerGISModel.assetId!,
      assetTypeId: event.gasCouplerGISId,
      dataList: listOfGasCouplerGIS,
      controller: gasCouplerGISController,
      context: event.context,
      assetPath: AssetPath.coupler,
      filteredList: listOfFilterGasCouplerGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectReducerGISValue(SelectReducerGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasReducerGISModel.assetId!,
      assetTypeId: event.gasReducerGISId,
      dataList: listOfGasReducerGIS,
      controller: gasReducerGISController,
      context: event.context,
      assetPath: AssetPath.reduce,
      filteredList: listOfFilterGasReducerGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectEndCapGISValue(SelectEndCapGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasEndCapGISModel.assetId!,
      assetTypeId: event.gasEndCapGISId,
      dataList: listOfGasEndCapGIS,
      controller: gasEndCapGISController,
      context: event.context,
      assetPath: AssetPath.endcap,
      filteredList: listOfFilterGasEndCapGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _selectConsumerGISValue(
      SelectConsumerGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasConsumerGISModel.assetId!,
      assetTypeId: event.gasConsumerGISId,
      dataList: listOfGasConsumerGIS,
      controller: gasConsumerGISController,
      context: event.context,
      assetPath: AssetPath.consumer,
      filteredList: listOfFilterConsumerGIS,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    Set<Marker> tempMarker = Set.from(markersPointList);
    for (var polyData in polylinePointList) {
      for (int i = 0; i < polyData.points.length - 1; i++) {
        final start = polyData.points[i];
        final end = polyData.points[i + 1];
        if (NearestPolylinePoint.isPointNearLine(
            event.latLngOnTap, start, end, 2)) {
          tempMarker.add(
            Marker(
              markerId: MarkerId('Pipeline'),
              position: event.latLngOnTap,
              infoWindow: InfoWindow(title: 'Create Report Incident'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
              onTap: () async {
                await _handleMarkerTap(
                    context: event.context, closestPoint: event.latLngOnTap);
              },
            ),
          );
          break;
        }
      }
    }
    markersPointList = tempMarker;
    _eventCompleted(emit);
  }

  Future<void> _handleMarkerTap(
      {required BuildContext context, required LatLng closestPoint}) async {
     AppConfig.instanceInit()?.setMarkerPoint(
        newPointMarkerLat: closestPoint.latitude.toString(),
        newPointMarkerLong: closestPoint.longitude.toString());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (BuildContext context) {
          return AlertDialogTwoBtnWidget(mContext: context);
        });
  }

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    await showDialog(
        context: event.context,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: BlocProvider.of<ReportAlertBloc>(context),
            child: ReportPopWidget(
              mContext: event.context,
            ),
          );
        });
    _eventCompleted(emit);
  }

  _clearTextField() async {
    checkBoxTf = false;
    isGasTfLoader = false;
    checkBoxValve = false;
    isGasValveLoader = false;
    checkBoxRegulator = false;
    isGasRegulatorLoader = false;
    checkBoxTee = false;
    isGasTeeLoader = false;
    checkBoxElbow = false;
    isGasElbowLoader = false;
    checkBoxCoupler = false;
    isGasCouplerLoader = false;
    checkBoxReducer = false;
    isGasReducerLoader = false;
    checkBoxEndCap = false;
    isGasEndCapLoader = false;
    checkBoxConsumer = false;
    isGasConsumerLoader = false;
    tfGisController.text = "";
    gasValveGISController.text = "";
    gasRegulatorGISController.text = "";
    gasTeeGISController.text = "";
    gasElbowGISController.text = "";
    gasCouplerGISController.text = "";
    gasReducerGISController.text = "";
    gasEndCapGISController.text = "";
    gasConsumerGISController.text = "";
  }

  _clearPopTextField() {
    isGasTfLoader = false;
    isGasValveLoader = false;
    isGasRegulatorLoader = false;
    isGasTeeLoader = false;
    isGasElbowLoader = false;
    isGasCouplerLoader = false;
    isGasReducerLoader = false;
    isGasEndCapLoader = false;
    tfGisController.text = "";
    gasValveGISController.text = "";
    gasRegulatorGISController.text = "";
    gasTeeGISController.text = "";
    gasElbowGISController.text = "";
    gasCouplerGISController.text = "";
    gasReducerGISController.text = "";
    gasEndCapGISController.text = "";
    gasConsumerGISController.text = "";
  }

  _clearMarkerPolyline() {
    polylinePointList = {};
    filterPolyline = {};
    polylinePointList = {...pipePolylinePointList};
  }

  _updateMarkerPolyline() {
    polylinePointList = {...pipePolylinePointList, ...filterPolyline};
  }

  _eventCompleted(Emitter<ReportAlertState> emit) {
    emit(FetchReportAlertDataState(
      isLoader: isLoader,
      isPipelineLoader: isPipelineLoader,
      checkBoxTf: checkBoxTf,
      isGasTfLoader: isGasTfLoader,
      checkBoxValve: checkBoxValve,
      isGasValveLoader: isGasValveLoader,
      checkBoxRegulator: checkBoxRegulator,
      isGasRegulatorLoader: isGasRegulatorLoader,
      checkBoxTee: checkBoxTee,
      isGasTeeLoader: isGasTeeLoader,
      checkBoxElbow: checkBoxElbow,
      isGasElbowLoader: isGasElbowLoader,
      checkBoxCoupler: checkBoxCoupler,
      isGasCouplerLoader: isGasCouplerLoader,
      checkBoxReducer: checkBoxReducer,
      isGasReducerLoader: isGasReducerLoader,
      checkBoxEndCap: checkBoxEndCap,
      isGasEndCapLoader: isGasEndCapLoader,
      checkBoxConsumer: checkBoxConsumer,
      isGasConsumerLoader: isGasConsumerLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      nameofLocation: nameofLocation,
      role: role,
      cameraPosition: cameraPosition,
      googleMapController: googleMapController,
      currentMapType: currentMapType,
      markersPointList: Set.of(markersPointList),
      circles: Set.of(circles),
      currentPosition: currentPosition,
      loginPosition: loginPosition,
      polylinePointList: Set.of(polylinePointList),
      pipelineNetworkModel: pipelineNetworkModel,
      pipelineNetworkData: pipelineNetworkData,
      listOfPipelineNetwork: listOfPipelineNetwork,
      tfGisController: tfGisController,
      gasValveGISController: gasValveGISController,
      gasRegulatorGISController: gasRegulatorGISController,
      gasTeeGISController: gasTeeGISController,
      gasElbowGISController: gasElbowGISController,
      gasCouplerGISController: gasCouplerGISController,
      gasReducerGISController: gasReducerGISController,
      gasEndCapGISController: gasEndCapGISController,
      gasConsumerGISController: gasConsumerGISController,
      listOfTfGisId: listOfTfGisId,
      listOfGasValveGISId: listOfGasValveGISId,
      listOfGasRegulatorGISId: listOfGasRegulatorGISId,
      listOfGasTeeGISId: listOfGasTeeGISId,
      listOfGasElbowGISId: listOfGasElbowGISId,
      listOfGasCouplerGISId: listOfGasCouplerGISId,
      listOfGasReducerGISId: listOfGasReducerGISId,
      listOfGasEndCapGISId: listOfGasEndCapGISId,
      listOfGasConsumerGISId: listOfGasConsumerGISId,
    ));
  }
}
