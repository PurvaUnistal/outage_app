import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/helper/navigate_alert_helper.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/widget/navigate_pop_widget.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ConsumerGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GisConfig.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ValveGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/getNearestPoint.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigateAlertBloc extends Bloc<NavigateAlertEvent, NavigateAlertState> {
  NavigateAlertBloc() : super(NavigateAlertInitialState()) {
    on<NavigateAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectCurrentMarkerButtonEvent>(_selectCurrentMarkerButton);
    on<SelectGoogleMapButtonEvent>(_selectGoogleMapButton);
    on<SelectGoogleRouteDirEvent>(_selectGoogleRouteDirEvent);
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
    on<NavigateAlertOnCameraIdleEvent>(_onCameraIdleEvent);

    on<ResetFilterEvent>(_onResetFilterEvent);
  }

  bool isLoader = false;
  bool isMapDir = false;
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

  String role = '';
  String baseUrl = '';
  String loginLat = '';
  String loginLong = '';
  String nameofLocation = '';
  String googleMapsUrl = "";

  TextEditingController tfGisController = TextEditingController();
  TextEditingController gasValveGISController = TextEditingController();
  TextEditingController gasRegulatorGISController = TextEditingController();
  TextEditingController gasTeeGISController = TextEditingController();
  TextEditingController gasElbowGISController = TextEditingController();
  TextEditingController gasCouplerGISController = TextEditingController();
  TextEditingController gasReducerGISController = TextEditingController();
  TextEditingController gasEndCapGISController = TextEditingController();
  TextEditingController startLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();
  TextEditingController gasConsumerGISController = TextEditingController();

  GetPipelineGisModel gasPipelineModel = GetPipelineGisModel();
  List<GetPipelineGisData> listOfPipelineGIS = [];

  GetGasValueGISModel fittingGISModel = GetGasValueGISModel();
  List<GetGasValueGISData> listOfFittingGIS = [];

  TFGISModel tfGisModel = TFGISModel();
  List<TFGISData> listOfTfGis = [];
  List<TFGISData> listOfFilterTfGis = [];
  List<String> listOfTfGisId = [];

  ValveGISModel gasValueGISModel = ValveGISModel();
  List<ValveGISData> listOfGasValueGIS = [];
  List<ValveGISData> listOfFilterGasValueGIS = [];
  List<String> listOfGasValveGISId = [];

  RegulatorGISModel gasRegulatorGISModel = RegulatorGISModel();
  List<RegulatorGISData> listOfGasRegulatorGIS = [];
  List<RegulatorGISData> listOfFilterGasRegulatorGIS = [];
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

  ConsumerGISModel gasConsumerGISModel = ConsumerGISModel();
  List<ConsumerGISData> listOfGasConsumerGIS = [];
  List<ConsumerGISData> listOfFilterConsumerGIS = [];
  List<String> listOfGasConsumerGISId = [];

  GetPipelineNetworkModel pipelineNetworkModel = GetPipelineNetworkModel();
  PipelineNetworkData pipelineNetworkData = PipelineNetworkData();
  List<PipelineNetworkData> listOfPipelineNetwork = [];

  PipelineModel pipelineModel = PipelineModel();
  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];

  LatLng currentPosition = LatLng(0, 0);
  LatLng latLngOnTap = LatLng(0, 0);
  List<LatLng> points = [];
  List<LatLng> allLatLongPoint = [];

  Set<Marker> tempMarker = {};
  Set<Marker> filterMarkerList = {};
  Set<Marker> finalMarker = {};
  Set<Marker> tfMarker = {};
  Set<Marker> valveMarker = {};
  Set<Marker> regularMarker = {};
  Set<Marker> consumerMarker = {};
  Set<Marker> markersPointList = {};

  Set<Polyline> polylinePointList = {};
  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> filterPolyline = {};
  Set<Polyline> finalPolyline = {};

  MapType currentMapType = MapType.normal;
  Completer<GoogleMapController> googleMapController = Completer();

  CameraPosition position = CameraPosition(
    target: LatLng(0, 0),
    zoom: AppString.zoom,
  );

  Timer? _timer;

  @override
  close() {
    _timer?.cancel();
    return super.close();
  }

  _pageLoad(NavigateAlertLoadEvent event, emit) async {
    emit(NavigateAlertInitialState());
    isLoader = false;
    _initializeAllModels();
    ReportAlertHelper.clearCache();
    await _selectGISValue(
      assetTypeId: "",
      dataList: [],
      controller: TextEditingController(),
      context: event.context,
      assetPath: "",
      filteredList: [],
    );

    await _currentPointMarker();
    await _fetchGasPipelineGisApi(context: event.context, emit: emit);
    _eventCompleted(emit);
  }

  _initializeAllModels() async {
    isPipelineLoader = false;
    isMapDir = false;
    googleMapsUrl = "";
    await _clearTextField();
    gasPipelineModel = GetPipelineGisModel();
    listOfPipelineGIS = [];
    gasValueGISModel = ValveGISModel();
    listOfGasValueGIS = [];
    listOfFilterGasValueGIS = [];
    listOfGasValveGISId = [];
    fittingGISModel = GetGasValueGISModel();
    listOfFittingGIS = [];
    tfGisModel = TFGISModel();
    listOfTfGis = [];
    listOfFilterTfGis = [];
    listOfTfGisId = [];
    gasRegulatorGISModel = RegulatorGISModel();
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

    gasConsumerGISModel = ConsumerGISModel();
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
    latLngOnTap = LatLng(0, 0);

    markersPointList = {};
    filterMarkerList = {};
    tempMarker = {};

    filterPolyline = {};
    polylinePointList = {};
    pipePolylinePointList = {};
    points = [];
    allLatLongPoint = [];
    googleMapController = Completer();

    currentMapType = MapType.normal;
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
  }

  _startCacheClearTimer() {
    _timer = Timer.periodic(Duration(seconds: 16), (timer) async {
      log("Clearing Cache...");
      await ReportAlertHelper.clearCache();
    });
  }

  _fetchGasPipelineGisApi({required BuildContext context, emit}) async {
    if (await HiveDataBase.pipelineDataBox!.values.isEmpty) {
      var res = await ReportAlertHelper.getPipelineApi(
        context: context,
        latitude:
            AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
        longitude:
            AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
      );
      if (res != null && res.data != null) {
        listOfPipeline = res.data!;
      }
    } else {
      listOfPipeline = await HiveDataBase.pipelineDataBox!.values.toList();
    }
    if (listOfPipeline.isNotEmpty) {
      finalPolyline.clear();
      finalMarker.clear();
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

  Future<void> _filterVisiblePolyline() async {
    final controller = await googleMapController.future;
    final bounds = await controller.getVisibleRegion();
    pipePolylinePointList =
        finalPolyline.where((polyline) {
          return polyline.points.any(
            (point) => DecodePolyline.isPointInBounds(point, bounds),
          );
        }).toSet();
    markersPointList =
        finalMarker.where((marker) {
          return [
            marker.position,
          ].any((points) => DecodePolyline.isPointInBounds(points, bounds));
        }).toSet();

    _updateMarkerPolyline();
  }

  _updateMarkerPolyline() {
    polylinePointList = {...pipePolylinePointList, ...filterPolyline};
    markersPointList = {...markersPointList, ...filterMarkerList};
    print("pipePolylinePointList-->${pipePolylinePointList.length}");
    print("filterPolyline-->${filterPolyline.length}");
    print("markersPointList-->${markersPointList.length}");
    print("filterMarkerList-->${filterMarkerList.length}");
  }

  _onCameraIdleEvent(NavigateAlertOnCameraIdleEvent event, emit) async {
    await ReportAlertHelper.clearCache();
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  gotoInitialPosition(LatLng location) async {
    position = CameraPosition(target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  _fetchTFGisApi({required BuildContext context, emit}) async {
    if (checkBoxTf == true) {
      try {
        if (await HiveDataBase.tfGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getTFGisApi(context: context);
          if (res != null) {
            tfGisModel = res;
            if (tfGisModel.data != null) {
              listOfTfGis = tfGisModel.data!;
            }
          }
        } else {
          listOfTfGis = await HiveDataBase.tfGISBox!.values.toList();
        }
        if (listOfTfGis.isNotEmpty) {
          listOfTfGisId = listOfTfGis.map((e) => e.id!).toList();
          final customIcon = await ReportAlertHelper.markerAsset(AssetPath.tf);
          for (int i = 0; i < listOfTfGis.length; i++) {
            final data = listOfTfGis[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(data.latitude!),
                double.parse(data.longitude!),
              );
              Set<Marker> marker = NavigateAlertHelper.markerPoint(
                icon: customIcon,
                position: latLngList,
                context: context,
                assetsTypeId: data.id ?? "",
              );
              tfMarker.addAll(marker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          finalMarker.addAll(tfMarker);
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during TFGis API fetching: $e");
      }
    }
    _eventCompleted(emit);
  }


  _fetchGasValueGisApi({required BuildContext context, emit}) async {
    if (checkBoxValve == true) {
      try {
        if (await HiveDataBase.valveGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getGasValueGisApi(context: context);
          if (res != null) {
            gasValueGISModel = res;
            if (gasValueGISModel.data != null) {
              listOfGasValueGIS = gasValueGISModel.data!;
            }
          }
        } else {
          listOfGasValueGIS = await HiveDataBase.valveGISBox!.values.toList();
        }
        if (listOfGasValueGIS.isNotEmpty) {
          listOfGasValveGISId = listOfGasValueGIS.map((e) => e.valveId!).toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.valve,
          );
          for (int i = 0; i < listOfGasValueGIS.length; i++) {
            final data = listOfGasValueGIS[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(data.latitude!),
                double.parse(data.longitude!),
              );
              Set<Marker> marker = NavigateAlertHelper.markerPoint(
                icon: customIcon,
                position: latLngList,
                context: context,
                assetsTypeId: data.valveId ?? "",
              );
              finalMarker.addAll(marker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Valve GIS API fetching: $e");
      }
    }

    _eventCompleted(emit);
  }

  _fetchGasRegulatorGisApi({required BuildContext context, emit}) async {
    if (checkBoxRegulator == true) {
      try {
        if (await HiveDataBase.regulatorGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getRegulatorGisApi(context: context);
          if (res != null) {
            gasRegulatorGISModel = res;
            if (gasRegulatorGISModel.data != null) {
              listOfGasRegulatorGIS = gasRegulatorGISModel.data!;
            }
          }
        } else {
          listOfGasRegulatorGIS = await HiveDataBase.regulatorGISBox!.values.toList();
        }
        if (listOfGasRegulatorGIS.isNotEmpty) {
          listOfGasRegulatorGISId =
              listOfGasRegulatorGIS.map((e) => e.id!).toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.regulator,
          );
          for (int i = 0; i < listOfGasRegulatorGIS.length; i++) {
            final data = listOfGasRegulatorGIS[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(data.latitude!),
                double.parse(data.longitude!),
              );
              Set<Marker> marker = NavigateAlertHelper.markerPoint(
                icon: customIcon,
                position: latLngList,
                context: context,
                assetsTypeId: data.id ?? "",
              );
              finalMarker.addAll(marker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Regulator GIS API fetching: $e");
      }
    }

    _eventCompleted(emit);
  }


  _fetchGasConsumerGisApi({required BuildContext context, emit}) async {
    if (checkBoxConsumer == true) {
      try {
        if (await HiveDataBase.consumerGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getConsumerGisApi(context: context);
          if (res != null) {
            gasConsumerGISModel = res;
            if (gasConsumerGISModel.data != null) {
              listOfGasConsumerGIS = gasConsumerGISModel.data!;
            }
          }
        } else {
          listOfGasConsumerGIS = await HiveDataBase.consumerGISBox!.values.toList();
        }
        if (listOfGasConsumerGIS.isNotEmpty) {
          listOfGasConsumerGISId =
              listOfGasConsumerGIS.map((e) => e.id!).toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.consumer,
          );
          for (int i = 0; i < listOfGasConsumerGIS.length; i++) {
            final data = listOfGasConsumerGIS[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(data.latitude!),
                double.parse(data.longitude!),
              );
              Set<Marker> marker = NavigateAlertHelper.markerPoint(
                icon: customIcon,
                position: latLngList,
                context: context,
                assetsTypeId: data.id ?? "",
              );
              finalMarker.addAll(marker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }

    _eventCompleted(emit);
  }


  _fetchGasTeeGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getTeeGisApi(context: context);
    if (res != null) {
      gasTeeGISModel = res;
      if (gasTeeGISModel.data != null) {
        listOfGasTeeGIS = gasTeeGISModel.data!;
        listOfGasTeeGISId = listOfGasTeeGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasElbowGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getElbowGisApi(context: context);
    if (res != null) {
      gasElbowGISModel = res;
      if (gasElbowGISModel.data != null) {
        listOfGasElbowGIS = gasElbowGISModel.data!;
        listOfGasElbowGISId = listOfGasElbowGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasCouplerGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getCouplerGisApi(context: context);
    if (res != null) {
      gasCouplerGISModel = res;
      if (gasCouplerGISModel.data != null) {
        listOfGasCouplerGIS = gasCouplerGISModel.data!;
        listOfGasCouplerGISId = listOfGasCouplerGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasReducerGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getReducerGisApi(context: context);
    if (res != null) {
      gasReducerGISModel = res;
      if (gasReducerGISModel.data != null) {
        listOfGasReducerGIS = gasReducerGISModel.data!;
        listOfGasReducerGISId = listOfGasReducerGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchGasEndCapGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getEndCapGisApi(context: context);
    if (res != null) {
      gasEndCapGISModel = res;
      if (gasEndCapGISModel.data != null) {
        listOfGasEndCapGIS = gasEndCapGISModel.data!;
        listOfGasEndCapGISId = listOfGasEndCapGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  _fetchPipelineNetworkApi({
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
          final gisConfig = await _getActiveGisConfig();
          for (int i = 0; i < listOfPipelineNetwork.length; i++) {
            final data = listOfPipelineNetwork[i];
            if (data.geomencode != null && data.geomencode!.isNotEmpty) {
              try {
                List<LatLng> filterLatLngGis =
                    await DecodePolyline.decodePolyline(data.geomencode!);
                final color = ReportAlertHelper.getPolylineColor(
                  int.tryParse(data.nominaldia ?? '0') ?? 0,
                );
                Set<Polyline> polyline = ReportAlertHelper.polylinePoint(
                  i: i,
                  color: color,
                  position: filterLatLngGis,
                  context: context,
                );
                gisConfig?.polylineList?.addAll(polyline);
                filterPolyline.addAll(polyline);
              } catch (e) {
                print("Error decoding polyline at index $i: $e");
              }
            }
          }
          _updateMarkerPolyline();
        } else {
          Utils.errorSnackBar(
            msg: "No pipeline data available.",
            context: context,
          );
        }
      } else {
        Utils.errorSnackBar(
          msg: "Failed to fetch pipeline network data.",
          context: context,
        );
      }
    } catch (e) {
      Utils.errorSnackBar(
        msg: "An error occurred: ${e.toString()}",
        context: context,
      );
    }
  }

  Future<GisConfig?> _getActiveGisConfig() async {
    if (tfGisController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.tf,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasValveGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.valve,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasRegulatorGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.regulator,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasTeeGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.tee,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasElbowGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.elbow,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasCouplerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.coupler,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasReducerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.reduce,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasEndCapGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.endcap,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
      );
    } else if (gasConsumerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.consumer,
        markerList: filterMarkerList,
        polylineList: filterPolyline,
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
      print("Current Position: $currentPosition");
      position = CameraPosition(target: currentPosition, zoom: 14);
      gotoInitialPosition(currentPosition);
    }
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTf = event.checkBoxTf;
    if (checkBoxTf == true) {
      isGasTfLoader = true;
      _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context, emit: emit);
    } else {
      finalMarker.removeWhere((marker) => tfMarker.contains(marker));
      tfMarker.clear();
      _eventCompleted(emit);
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
      await _fetchGasValueGisApi(context: event.context, emit: emit);
    } else {
      finalMarker.removeWhere((marker) => valveMarker.contains(marker));
      valveMarker.clear();
      _eventCompleted(emit);
    }
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxRegulatorGis(
    SelectCheckBoxRegulatorGisEvent event,
    emit,
  ) async {
    await _clearPopTextField();
    checkBoxRegulator = event.checkBoxRegulator;
    if (checkBoxRegulator == true) {
      isGasRegulatorLoader = true;
      _eventCompleted(emit);
      await _fetchGasRegulatorGisApi(context: event.context, emit: emit);
    } else {
      finalMarker.removeWhere((marker) => regularMarker.contains(marker));
      regularMarker.clear();
      _eventCompleted(emit);
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
      await _fetchGasConsumerGisApi(context: event.context, emit: emit);
    } else {
      finalMarker.removeWhere((marker) => consumerMarker.contains(marker));
      consumerMarker.clear();
      _eventCompleted(emit);
    }
    isGasConsumerLoader = false;
    _eventCompleted(emit);
  }

  _selectGISValue({
    required String assetTypeId,
    required List dataList,
    required TextEditingController controller,
    required BuildContext context,
    required String assetPath,
    required List filteredList,
  }) async {
    filteredList.clear();
    assetTypeId == '';
    _clearMarkerPolyline();
    controller.text = assetTypeId;
    if (controller.text.isNotEmpty) {
      filteredList.addAll(
        dataList.where((data) {
          if (gasValveGISController.text.isNotEmpty) {
            return data.valveId.toString() == assetTypeId;
          } else {
            return data.toString() == assetTypeId;
          }
        }).toList(),
      );
      if (filteredList.isNotEmpty) {
        final iconBytes = await ReportAlertHelper.markerAsset(assetPath);
        LatLng location = LatLng(
          double.parse(filteredList[0].latitude!),
          double.parse(filteredList[0].longitude!),
        );
        Set<Marker> markers = await NavigateAlertHelper.markerPoint(
          position: location,
          context: context,
          icon: iconBytes,
          assetsTypeId: assetTypeId,
        );
        await _fetchPipelineNetworkApi(
          context: context,
          latitude: location.latitude.toString(),
          longitude: location.longitude.toString(),
        );
        tempMarker.addAll(markers);
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

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
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

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
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

  _selectRegulatorGISValue(SelectRegulatorGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
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

  _selectConsumerGISValue(SelectConsumerGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
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

  _onResetFilterEvent(ResetFilterEvent event, emit) async {
    tempMarker = {};
    await gotoInitialPosition(points[0]);
    _clearTextField();
    _clearMarkerPolyline();
    Navigator.pop(event.context, true);
    _eventCompleted(emit);
  }


  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    try {
      final currentPoint = await CurrentLocation.getCurrentLocation();
      final Set<Marker> tempMarkers = Set.from(markersPointList);
      latLngOnTap = event.latLngOnTap;
      isMapDir = true;

      googleMapsUrl =
      "https://www.google.com/maps/dir/?api=1&origin=${currentPoint?.latitude},${currentPoint?.longitude}&destination=${latLngOnTap.latitude},${latLngOnTap.longitude}&travelmode=driving&dir_action=navigate";
      print("googleMapsUrl --> $googleMapsUrl");

      final placemarks = await placemarkFromCoordinates(
        latLngOnTap.latitude,
        latLngOnTap.longitude,
      );

      nameofLocation = placemarks.isNotEmpty
          ? '${placemarks[0].administrativeArea}, ${placemarks[0].locality}, ${placemarks[0].country}'
          : 'Unknown Location';

      print("nameofLocation --> $nameofLocation");
      for (final poly in polylinePointList) {
        for (int i = 0; i < poly.points.length - 1; i++) {
          final start = poly.points[i];
          final end = poly.points[i + 1];

          if (NearestPolylinePoint.isPointNearLine(latLngOnTap, start, end)) {
            tempMarkers.add(
              Marker(
                markerId: const MarkerId('Pipeline'),
                position: latLngOnTap,
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Pickup Point',
                  snippet: nameofLocation,
                ),
              ),
            );
            break;
          }
        }
      }

      markersPointList = tempMarkers;
      _eventCompleted(emit);
    } catch (e) {
      print("Error in _selectGoogleMapButton: $e");
    }
  }



  _selectGoogleRouteDirEvent(SelectGoogleRouteDirEvent event, emit) async {
    if (isMapDir == true) {
      isMapDir = true;
      final Uri uri = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(uri)) {
        print("uri-->${uri}");
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    }
    _eventCompleted(emit);
  }

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    await showDialog(
      context: event.context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<NavigateAlertBloc>(context),
          child: NavigatePopWidget(mContext: event.context),
        );
      },
    );
    _eventCompleted(emit);
  }

  _clearTextField() {
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

  _clearMarkerPolyline() {
    filterPolyline = {};
    polylinePointList = {};
    polylinePointList = {...pipePolylinePointList};
  }

  _eventCompleted(Emitter<NavigateAlertState> emit) {
    emit(
      FetchNavigateAlertDataState(
        isLoader: isLoader,
        isMapDir: isMapDir,
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
        baseUrl: baseUrl,
        nameofLocation: nameofLocation,
        role: role,
        position: position,
        googleMapController: googleMapController,
        currentMapType: currentMapType,
        markersPointList: Set.of(markersPointList),
        currentPosition: currentPosition,
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
        startLocationController: startLocationController,
        destinationLocationController: destinationLocationController,
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
      ),
    );
  }
}
