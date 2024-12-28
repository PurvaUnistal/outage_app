import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/helper/navigate_alert_helper.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/presentation/widget/navigate_pop_widget.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GisConfig.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';

class NavigateAlertBloc extends Bloc<NavigateAlertEvent, NavigateAlertState> {
  NavigateAlertBloc() : super(NavigateAlertInitialState()) {
    on<NavigateAlertLoadEvent>(_pageLoad);
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
    on<OnCameraMoveEvent>(_onCameraMoveEvent);
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

  LatLng currentPosition = LatLng(0, 0);
  LatLng loginPosition = LatLng(0, 0);
  LatLng latLngOnTap = LatLng(0, 0);
  List<LatLng> latLngGis = [];
  List<LatLng> allLatLong = [];

  Set<Marker> markersPointList = {};
  Set<Marker> tfMarkersPointList = {};
  Set<Marker> valveMarkersPointList = {};
  Set<Marker> regulatorMarkersPointList = {};
  Set<Marker> teeMarkersPointList = {};
  Set<Marker> elbowMarkersPointList = {};
  Set<Marker> couplerMarkersPointList = {};
  Set<Marker> reducerMarkersPointList = {};
  Set<Marker> endCapMarkersPointList = {};
  Set<Marker> consumerMarkersPointList = {};

  Set<Polyline> polylinePointList = {};
  Set<Polyline> tfPolylineList = {};
  Set<Polyline> valvePolylineList = {};
  Set<Polyline> regulatorPolylineList = {};
  Set<Polyline> teePolylineList = {};
  Set<Polyline> elbowPolylineList = {};
  Set<Polyline> couplerPolylineList = {};
  Set<Polyline> reducerPolylineList = {};
  Set<Polyline> endCapPolylineList = {};
  Set<Polyline> consumerPolylineList = {};

  MapType currentMapType = MapType.normal;
  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: AppString.zoom,
  );

  _pageLoad(NavigateAlertLoadEvent event, emit) async {
    emit(NavigateAlertInitialState());
    isLoader = false;
    isPipelineLoader = false;
    await _clearMarkerPolylineField();
    await _clearTextField();
    startLocationController.text = "";
    destinationLocationController.text = "";
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
    latLngOnTap = LatLng(0, 0);
    latLngGis = [];
    markersPointList = {};
    polylinePointList = {};
    googleMapController = Completer();
    currentMapType = MapType.normal;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    loginLat = await SharedPref.getString(key: PrefsValue.loginLat);
    loginLong = await SharedPref.getString(key: PrefsValue.loginLong);
    loginPosition = LatLng(
        double.parse(loginLat.toString()), double.parse(loginLong.toString()));
    await ReportAlertHelper.clearCache();
    await _currentLoginLocation();
    await _fetchGasPipelineGisApi(context: event.context);
    _eventCompleted(emit);
  }

  _currentLoginLocation() async {
    final Uint8List markerIcon =
        await ReportAlertHelper.getBytesFromAsset(AssetPath.loginPin, 100);
    cameraPosition =
        CameraPosition(target: loginPosition, zoom: AppString.zoom);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(loginLat.toString()), double.parse(loginLong.toString()));
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      nameofLocation = '${place.locality}, (${place.country})';
    }
    markersPointList.add(Marker(
      markerId: MarkerId(nameofLocation),
      position: loginPosition,
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
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

  Future<dynamic> _fetchGasTeeGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getTeeGisApi(context: context);

    if (res != null) {
      gasTeeGISModel = res;
      listOfGasTeeGIS = gasTeeGISModel.data ?? [];

      if (listOfGasTeeGIS.isNotEmpty) {
        listOfGasTeeGISId = listOfGasTeeGIS.map((e) => e.id!).toList();
      }

      return res;
    }

    return null; // Explicitly return null if no data is fetched
  }


  Future<dynamic> _fetchGasElbowGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getElbowGisApi(context: context);

    if (res != null) {
      gasElbowGISModel = res;
      listOfGasElbowGIS = gasElbowGISModel.data ?? [];

      if (listOfGasElbowGIS.isNotEmpty) {
        listOfGasElbowGISId = listOfGasElbowGIS.map((e) => e.id!).toList();
      }

      return res;
    }

    return null; // Explicitly return null if no data is fetched
  }


  Future<dynamic> _fetchGasCouplerGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getCouplerGisApi(context: context);
    if (res != null) {
      gasCouplerGISModel = res;
      listOfGasCouplerGIS = gasCouplerGISModel.data ?? [];
      if (listOfGasCouplerGIS.isNotEmpty) {
        listOfGasCouplerGISId = listOfGasCouplerGIS.map((e) => e.id!).toList();
      }
      return res;
    }
    return null;
  }


  Future<dynamic> _fetchGasReducerGisApi(
      {required BuildContext context}) async {
    var res = await ReportAlertHelper.getReducerGisApi(context: context);
    if (res != null) {
      gasReducerGISModel = res;
      listOfGasReducerGIS = gasReducerGISModel.data ?? [];
      if (listOfGasReducerGIS.isNotEmpty) {
        listOfGasReducerGISId = listOfGasReducerGIS.map((e) => e.id!).toList();
      }
      return res;
    }
    return null;
  }

  Future<dynamic> _fetchGasEndCapGisApi({required BuildContext context}) async {
    var res = await ReportAlertHelper.getEndCapGisApi(context: context);
    if (res != null) {
      gasEndCapGISModel = res;
      listOfGasEndCapGIS = gasEndCapGISModel.data ?? [];
      if (listOfGasEndCapGIS.isNotEmpty) {
        listOfGasEndCapGISId = listOfGasEndCapGIS.map((e) => e.id!).toList();
      }
      return res;
    }

    return null;
  }

  Future<dynamic> _fetchGasConsumerGisApi(
      {required BuildContext context}) async {
    var res = await ReportAlertHelper.getConsumerGisApi(context: context);
    if (res != null) {
      gasConsumerGISModel = res;
      listOfGasConsumerGIS = gasConsumerGISModel.data ?? [];
      if (listOfGasConsumerGIS.isNotEmpty) {
        listOfGasConsumerGISId =
            listOfGasConsumerGIS.map((e) => e.id!).toList();
      }
      return res;
    }
    return null;
  }
  _fetchGasPipelineGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getPipelineApi(
      context: context,
      latitude: loginPosition.latitude.toString(),
      longitude: loginPosition.longitude.toString(),
    );
    if (res != null) {
      pipelineModel = res;
      if (pipelineModel.data != null) {
        listOfPipeline = pipelineModel.data!;
        for (var allPipeline in listOfPipeline) {
          final colors = ReportAlertHelper.getPolylineColor(int.tryParse(allPipeline.nominaldia!) ?? 0);
          latLngGis = await DecodePolyline.decodePolyline(allPipeline.geomencode!);
          var listOfPolyline = await ReportAlertHelper.createPolyLine(
              color: colors,
              latlngList: latLngGis,
              context: context);

          polylinePointList.addAll(listOfPolyline);
        }
      }
    }
  }
  Future<void> _fetchPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    await _clearMarkerPolylineField();
    var res = await ReportAlertHelper.getPipelineNetworkApi(
      context: context,
      latitude: latitude,
      longitude: longitude,
    );
    if (res != null) {
      pipelineNetworkModel = res;
      if (pipelineNetworkModel.data?.isNotEmpty ?? false) {
        listOfPipelineNetwork = pipelineNetworkModel.data!;
        for (var pipeline in listOfPipelineNetwork) {
          latLngGis = await DecodePolyline.decodePolyline(pipeline.geomencode!);

          // Process markers and polylines based on active GIS controller
          var gisConfig = _getActiveGisConfig();
          if (gisConfig != null) {
            final Uint8List? iconBytes = await ReportAlertHelper.getBytesFromAsset(gisConfig.assetPath, 80);
            var markers = await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.fromBytes(iconBytes!),
            );
         /*   var polylines = await ReportAlertHelper.createPolyLine(
              color: gisConfig.polylineColor,
              latlngList: latLngGis,
              context: context,
            );*/
            gisConfig.markerList.addAll(markers);
          //  gisConfig.polylineList?.addAll(polylines);
            markersPointList.addAll(markers);
         //   polylinePointList.addAll(polylines);
          }
        }
      } else {
        Utils.errorSnackBar(msg: "No data Found", context: context);
        return;
      }

      // Update camera to the last marker
      if (markersPointList.isNotEmpty) {
        GoogleMapController controller = await googleMapController.future;
        currentPosition = LatLng(
          markersPointList.last.position.latitude,
          markersPointList.last.position.longitude,
        );
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition, zoom: 16),
          ),
        );
      }
    }
  }

  /// Returns the active GIS configuration based on controllers
  GisConfig? _getActiveGisConfig() {
    if (tfGisController.text.isNotEmpty) {
      print("tfMarkersPointList-->${tfMarkersPointList.length}");
      return GisConfig(
        assetPath: AssetPath.tf,
        polylineColor: Colors.yellow.shade900,
        markerList: tfMarkersPointList,
      //  polylineList: tfPolylineList,
      );
    } else if (gasValveGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.valve,
        polylineColor: Colors.deepOrange,
        markerList: valveMarkersPointList,
        polylineList: valvePolylineList,
      );
    } else if (gasRegulatorGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.regulator,
        polylineColor: Colors.yellowAccent.shade700,
        markerList: regulatorMarkersPointList,
        polylineList: regulatorPolylineList,
      );
    } else if (gasTeeGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.tee,
        polylineColor: Colors.green,
        markerList: teeMarkersPointList,
        polylineList: teePolylineList,
      );
    } else if (gasElbowGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.elbow,
        polylineColor: Colors.green,
        markerList: elbowMarkersPointList,
        polylineList: elbowPolylineList,
      );
    } else if (gasCouplerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.coupler,
        polylineColor: Colors.green,
        markerList: couplerMarkersPointList,
        polylineList: couplerPolylineList,
      );
    } else if (gasReducerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.reduce,
        polylineColor: Colors.green,
        markerList: reducerMarkersPointList,
        polylineList: reducerPolylineList,
      );
    } else if (gasEndCapGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.endcap,
        polylineColor: Colors.green,
        markerList: endCapMarkersPointList,
        polylineList: endCapPolylineList,
      );
    } else if (gasConsumerGISController.text.isNotEmpty) {
      return GisConfig(
        assetPath: AssetPath.consumer,
        polylineColor: Colors.green,
        markerList: consumerMarkersPointList,
       polylineList: consumerPolylineList,
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
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    GoogleMapController controller = await googleMapController.future;
    if (currentPoint != null) {
      currentPosition = LatLng(currentPoint.latitude, currentPoint.longitude);
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 14)));
      markersPointList.add(Marker(
        markerId: MarkerId(nameofLocation),
        position: currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
    _eventCompleted(emit);
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTf = event.checkBoxTf;
    isGasTfLoader = true;
    _eventCompleted(emit);
    await SharedPref.remove(key: PrefsValue.assetId);
    await _fetchTFGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "7");
    isGasTfLoader = false;
    _eventCompleted(emit);
  }

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    listOfFilterTfGis.clear();
    _clearMarkerPolylineField();
    tfGisController.text = event.tfGisId;
    if (tfGisController.text.isNotEmpty && gasValveGISController.text.isEmpty) {
      await SharedPref.setString(key: PrefsValue.assetTypeId, value: tfGisController.text,);
      listOfFilterTfGis = listOfTfGis.where((listData) => listData.id.toString() == event.tfGisId.toString())
          .toList();

      if (listOfFilterTfGis.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);

        final selectedTfGis = listOfFilterTfGis.first;
        await _fetchPipelineNetworkApi(
          context: event.context,
          latitude: selectedTfGis.latitude!,
          longitude: selectedTfGis.longitude!,
        );

        isPipelineLoader = false;
        _eventCompleted(emit);
      }
    }
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxValve = event.checkBoxValve;
    isGasValveLoader = true;
    _eventCompleted(emit);
    await SharedPref.remove(key: PrefsValue.assetId);
    await _fetchGasValueGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    listOfFilterGasValueGIS = [];
    _clearMarkerPolylineField();
    gasValveGISController.text = event.gasValveGISId;
    markersPointList = {};
    _currentLoginLocation();
    if (gasValveGISController.text.isNotEmpty && tfGisController.text.isEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasValveGISController.text);
      for (var listData in listOfGasValueGIS) {
        if (listData.id.toString() == event.gasValveGISId.toString()) {
          listOfFilterGasValueGIS.add(listData);
        }
      }
      if (listOfFilterGasValueGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasValueGIS[0].latitude!,
            longitude: listOfFilterGasValueGIS[0].longitude!);
        isPipelineLoader = false;
        _eventCompleted(emit);
      }
    }
  }

  _selectCheckBoxRegulatorGis(
      SelectCheckBoxRegulatorGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxRegulator = event.checkBoxRegulator;
    isGasRegulatorLoader = true;
    _eventCompleted(emit);
    await SharedPref.remove(key: PrefsValue.assetId);
    await _fetchGasRegulatorGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasRegulatorLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _selectRegulatorGISValue(
      SelectRegulatorGISValueEvent event, emit) async {
    listOfFilterGasRegulatorGIS.clear();
    _clearMarkerPolylineField();
    gasRegulatorGISController.text = event.gasRegulatorGISId;
    if (gasRegulatorGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetId, value: gasRegulatorGISModel.assetId ?? "");
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasRegulatorGISController.text);
      listOfFilterGasRegulatorGIS = listOfGasRegulatorGIS
          .where((data) => data.id.toString() == event.gasRegulatorGISId)
          .toList();
      if (listOfFilterGasRegulatorGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
          context: event.context,
          latitude: listOfFilterGasRegulatorGIS[0].latitude!,
          longitude: listOfFilterGasRegulatorGIS[0].longitude!,
        );
        isPipelineLoader = false;
        _eventCompleted(emit);
      }
    }
  }


  _selectCheckBoxTeeGis(SelectCheckBoxTeeGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTee = event.checkBoxTee;
    isGasTeeLoader = true;
    _eventCompleted(emit);
    await _fetchGasTeeGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasTeeLoader = false;
    _eventCompleted(emit);
  }

  _selectTeeGISValue(SelectTeeGISValueEvent event, emit) async {
    listOfFilterGasTeeGIS = [];
    _clearMarkerPolylineField();
    gasTeeGISController.text = event.gasTeeGISId;
    if (gasTeeGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasTeeGISController.text);
      for (var listData in listOfGasTeeGIS) {
        if (listData.id.toString() == event.gasTeeGISId.toString()) {
          listOfFilterGasTeeGIS.add(listData);
        }
      }
      if (listOfFilterGasTeeGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasTeeGIS[0].latitude!,
            longitude: listOfFilterGasTeeGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxElbowGis(SelectCheckBoxElbowGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxElbow = event.checkBoxElbow;
    isGasElbowLoader = true;
    _eventCompleted(emit);
    await _fetchGasElbowGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasElbowLoader = false;
    _eventCompleted(emit);
  }

  _selectElbowGISValue(SelectElbowGISValueEvent event, emit) async {
    listOfFilterGasElbowGIS = [];
    _clearMarkerPolylineField();
    gasElbowGISController.text = event.gasElbowGISId;
    if (gasElbowGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasElbowGISController.text);
      for (var listData in listOfGasElbowGIS) {
        if (listData.id.toString() == event.gasElbowGISId.toString()) {
          listOfFilterGasElbowGIS.add(listData);
        }
      }
      if (listOfFilterGasElbowGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasElbowGIS[0].latitude!,
            longitude: listOfFilterGasElbowGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxCouplerGis(SelectCheckBoxCouplerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxCoupler = event.checkBoxCoupler;
    isGasCouplerLoader = true;
    _eventCompleted(emit);
    await _fetchGasCouplerGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasCouplerLoader = false;
    _eventCompleted(emit);
  }

  _selectCouplerGISValue(SelectCouplerGISValueEvent event, emit) async {
    listOfFilterGasCouplerGIS = [];
    _clearMarkerPolylineField();
    gasCouplerGISController.text = event.gasCouplerGISId;
    if (gasCouplerGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasCouplerGISController.text);
      for (var listData in listOfGasCouplerGIS) {
        if (listData.id.toString() == event.gasCouplerGISId.toString()) {
          listOfFilterGasCouplerGIS.add(listData);
        }
      }
      if (listOfFilterGasCouplerGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasCouplerGIS[0].latitude!,
            longitude: listOfFilterGasCouplerGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxReducerGis(SelectCheckBoxReducerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxReducer = event.checkBoxReducer;
    isGasReducerLoader = true;
    _eventCompleted(emit);
    await _fetchGasReducerGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasReducerLoader = false;
    _eventCompleted(emit);
  }

  _selectReducerGISValue(SelectReducerGISValueEvent event, emit) async {
    listOfFilterGasReducerGIS = [];
    _clearMarkerPolylineField();

    gasReducerGISController.text = event.gasReducerGISId;
    if (gasReducerGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasReducerGISController.text);
      for (var listData in listOfGasReducerGIS) {
        if (listData.id.toString() == event.gasReducerGISId.toString()) {
          listOfFilterGasReducerGIS.add(listData);
        }
      }
      if (listOfFilterGasReducerGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasReducerGIS[0].latitude!,
            longitude: listOfFilterGasReducerGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxEndCapGis(SelectCheckBoxEndCapGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxEndCap = event.checkBoxEndCap;
    isGasEndCapLoader = true;
    _eventCompleted(emit);
    await _fetchGasEndCapGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasEndCapLoader = false;
    _eventCompleted(emit);
  }

  _selectEndCapGISValue(SelectEndCapGISValueEvent event, emit) async {
    listOfFilterGasEndCapGIS = [];
    _clearMarkerPolylineField();
    gasEndCapGISController.text = event.gasEndCapGISId;
    if (gasEndCapGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasEndCapGISController.text);
      for (var listData in listOfGasEndCapGIS) {
        if (listData.id.toString() == event.gasEndCapGISId.toString()) {
          listOfFilterGasEndCapGIS.add(listData);
        }
      }
      if (listOfFilterGasEndCapGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasEndCapGIS[0].latitude!,
            longitude: listOfFilterGasEndCapGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxConsumerGis(SelectCheckBoxConsumerGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxConsumer = event.checkBoxConsumer;
    isGasConsumerLoader = true;
    _eventCompleted(emit);
    await _fetchGasConsumerGisApi(context: event.context);
    await SharedPref.setString(
        key: PrefsValue.assetId, value: tfGisModel.assetId ?? "");
    isGasConsumerLoader = false;
    _eventCompleted(emit);
  }

  _selectConsumerGISValue(SelectConsumerGISValueEvent event, emit) async {
    listOfFilterConsumerGIS = [];
    _clearMarkerPolylineField();
    gasConsumerGISController.text = event.gasConsumerGISId;
    if (gasConsumerGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasConsumerGISController.text);
      for (var listData in listOfGasConsumerGIS) {
        if (listData.id.toString() == event.gasConsumerGISId.toString()) {
          listOfFilterConsumerGIS.add(listData);
        }
      }
      if (listOfFilterConsumerGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterConsumerGIS[0].latitude!,
            longitude: listOfFilterConsumerGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _onResetFilterEvent(ResetFilterEvent event, emit) async {
    _clearTextField();
    _clearMarkerPolylineField();
    await SharedPref.remove(
      key: PrefsValue.assetId,);
    await SharedPref.remove(
      key: PrefsValue.assetTypeId,);
    GoogleMapController controller = await googleMapController.future;
    currentPosition = LatLng(loginPosition.latitude, loginPosition.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: 14)));
    Navigator.pop(event.context, true);
    _eventCompleted(emit);
  }

  _onCameraMoveEvent(OnCameraMoveEvent event, emit) async {
    polylinePointList = {};

    if (allLatLong.isEmpty || !googleMapController.isCompleted) {
      return;
    }

    if (checkBoxTf || checkBoxValve || checkBoxRegulator || checkBoxConsumer) {
      return;
    }

    try {
      var controller = await googleMapController.future;
      LatLngBounds bounds = await controller.getVisibleRegion();

      var _visiblePolylinePoints = allLatLong.where(bounds.contains).toList();
      if (_visiblePolylinePoints.isEmpty) return;

      var listOfPolyline = await ReportAlertHelper.createPolyLine(
          color: Colors.deepPurple.shade800,
          latlngList: _visiblePolylinePoints,
          context: event.context);
      polylinePointList.addAll(listOfPolyline);
    } catch (e) {
      // Log or handle error
      print("Error in _onCameraMoveEvent: $e");
    }

    _eventCompleted(emit);
  }
  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    final Uint8List pinIcon =
        await ReportAlertHelper.getBytesFromAsset(AssetPath.pin, 50);
    Set<Marker> tempMarker = Set.from(markersPointList);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        event.latLngOnTap.latitude, event.latLngOnTap.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      nameofLocation =
          '${place.thoroughfare}, ${place.subLocality}, ${place.administrativeArea}, ${place.locality}, ${place.country}';
      print("nameofLocation-->${nameofLocation}");
    }
    tempMarker.add(
      Marker(
        markerId: MarkerId('Pipeline'),
        position: event.latLngOnTap,
        infoWindow: InfoWindow(title: 'Pickup Point', snippet: nameofLocation),
        icon: BitmapDescriptor.fromBytes(pinIcon),
      ),
    );
    markersPointList = tempMarker;
    _eventCompleted(emit);
  }

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    await _currentLoginLocation();
    await showDialog(
        context: event.context,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: BlocProvider.of<NavigateAlertBloc>(context),
            child: NavigatePopWidget(
              mContext: event.context,
            ),
          );
        });
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

  _clearMarkerPolylineField() {
    markersPointList = {};
    polylinePointList = {};
    _currentLoginLocation();
    latLngGis = [];
    tfMarkersPointList = {};
    valveMarkersPointList = {};
    regulatorMarkersPointList = {};
    teeMarkersPointList = {};
    elbowMarkersPointList = {};
    couplerMarkersPointList = {};
    reducerMarkersPointList = {};
    endCapMarkersPointList = {};
    tfPolylineList = {};
    valvePolylineList = {};
    regulatorPolylineList = {};
    teePolylineList = {};
    elbowPolylineList = {};
    couplerPolylineList = {};
    reducerPolylineList = {};
    endCapPolylineList = {};
    consumerMarkersPointList = {};
  }

  _eventCompleted(Emitter<NavigateAlertState> emit) {
    emit(FetchNavigateAlertDataState(
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
    ));
  }
}
