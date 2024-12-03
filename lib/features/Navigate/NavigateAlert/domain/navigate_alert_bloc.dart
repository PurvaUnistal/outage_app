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
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
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

  GetTfGisModel tfGisModel = GetTfGisModel();
  List<TfGisData> listOfTfGis = [];
  List<TfGisData> listOfFilterTfGis = [];
  List<String> listOfTfGisId = [];

  GetTfGisModel gasValueGISModel = GetTfGisModel();
  List<TfGisData> listOfGasValueGIS = [];
  List<TfGisData> listOfFilterGasValueGIS = [];
  List<String> listOfGasValveGISId = [];

  GetTfGisModel gasRegulatorGISModel = GetTfGisModel();
  List<TfGisData> listOfGasRegulatorGIS = [];
  List<TfGisData> listOfFilterGasRegulatorGIS = [];
  List<String> listOfGasRegulatorGISId = [];

  GetTfGisModel gasTeeGISModel = GetTfGisModel();
  List<TfGisData> listOfGasTeeGIS = [];
  List<TfGisData> listOfFilterGasTeeGIS = [];
  List<String> listOfGasTeeGISId = [];

  GetTfGisModel gasElbowGISModel = GetTfGisModel();
  List<TfGisData> listOfGasElbowGIS = [];
  List<TfGisData> listOfFilterGasElbowGIS = [];
  List<String> listOfGasElbowGISId = [];

  GetTfGisModel gasCouplerGISModel = GetTfGisModel();
  List<TfGisData> listOfGasCouplerGIS = [];
  List<TfGisData> listOfFilterGasCouplerGIS = [];
  List<String> listOfGasCouplerGISId = [];

  GetTfGisModel gasReducerGISModel = GetTfGisModel();
  List<TfGisData> listOfGasReducerGIS = [];
  List<TfGisData> listOfFilterGasReducerGIS = [];
  List<String> listOfGasReducerGISId = [];

  GetTfGisModel gasEndCapGISModel = GetTfGisModel();
  List<TfGisData> listOfGasEndCapGIS = [];
  List<TfGisData> listOfFilterGasEndCapGIS = [];
  List<String> listOfGasEndCapGISId = [];

  GetTfGisModel gasConsumerGISModel = GetTfGisModel();
  List<TfGisData> listOfGasConsumerGIS = [];
  List<TfGisData> listOfFilterConsumerGIS = [];
  List<String> listOfGasConsumerGISId = [];

  GetPipelineNetworkModel pipelineNetworkModel = GetPipelineNetworkModel();
  PipelineNetworkData pipelineNetworkData = PipelineNetworkData();
  List<PipelineNetworkData> listOfPipelineNetwork = [];

  LatLng currentPosition = LatLng(0, 0);
  LatLng loginPosition = LatLng(0, 0);
  LatLng latLngOnTap = LatLng(0, 0);
  List<LatLng> latLngGis = [];

  Set<Marker> markersPointList = {};
  Set<Marker> tfMarkersPointList = {};
  Set<Marker> valveMarkersPointList = {};
  Set<Marker> regulatorMarkersPointList = {};
  Set<Marker> teeMarkersPointList = {};
  Set<Marker> elbowMarkersPointList = {};
  Set<Marker> couplerMarkersPointList = {};
  Set<Marker> reducerMarkersPointList = {};
  Set<Marker> endCapMarkersPointList = {};

  Set<Polyline> polylineList = {};
  Set<Polyline> tfPolylineList = {};
  Set<Polyline> valvePolylineList = {};
  Set<Polyline> regulatorPolylineList = {};
  Set<Polyline> teePolylineList = {};
  Set<Polyline> elbowPolylineList = {};
  Set<Polyline> couplerPolylineList = {};
  Set<Polyline> reducerPolylineList = {};
  Set<Polyline> endCapPolylineList = {};

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
    gasValueGISModel = GetTfGisModel();
    listOfGasValueGIS = [];
    listOfFilterGasValueGIS = [];
    listOfGasValveGISId = [];
    fittingGISModel = GetGasValueGISModel();
    listOfFittingGIS = [];
    tfGisModel = GetTfGisModel();
    listOfTfGis = [];
    listOfFilterTfGis = [];
    listOfTfGisId = [];

    gasRegulatorGISModel = GetTfGisModel();
    listOfGasRegulatorGIS = [];
    listOfFilterGasRegulatorGIS = [];
    listOfGasRegulatorGISId = [];

    gasTeeGISModel = GetTfGisModel();
    listOfGasTeeGIS = [];
    listOfFilterGasTeeGIS = [];
    listOfGasTeeGISId = [];

    gasElbowGISModel = GetTfGisModel();
    listOfGasElbowGIS = [];
    listOfFilterGasElbowGIS = [];
    listOfGasElbowGISId = [];

    gasCouplerGISModel = GetTfGisModel();
    listOfGasCouplerGIS = [];
    listOfFilterGasCouplerGIS = [];
    listOfGasCouplerGISId = [];

    gasReducerGISModel = GetTfGisModel();
    listOfGasReducerGIS = [];
    listOfFilterGasReducerGIS = [];
    listOfGasReducerGISId = [];

    gasEndCapGISModel = GetTfGisModel();
    listOfGasEndCapGIS = [];
    listOfFilterGasEndCapGIS = [];
    listOfGasEndCapGISId = [];

    gasConsumerGISModel = GetTfGisModel();
    listOfGasConsumerGIS = [];
    listOfFilterConsumerGIS = [];
    listOfGasConsumerGISId = [];

    pipelineNetworkModel = GetPipelineNetworkModel();
    pipelineNetworkData = PipelineNetworkData();
    listOfPipelineNetwork = [];
    currentPosition = LatLng(0, 0);
    loginPosition = LatLng(0, 0);
    latLngOnTap = LatLng(0, 0);
    latLngGis = [];
    markersPointList = {};
    polylineList = {};
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
        listOfGasValveGISId = listOfGasValueGIS.map((e) => e.id!).toList();
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

  /*_fetchPipelineNetworkApi(
      {required BuildContext context,
      required String latitude,
      required String longitude}) async {
    await _clearMarkerPolylineField();
    var res = await ReportAlertHelper.getPipelineNetworkApi(
      context: context,
      latitude: latitude,
      longitude: longitude,
    );
    if (res != null) {
      pipelineNetworkModel = res;
      if (pipelineNetworkModel.data?.length != 0 &&
          pipelineNetworkModel.data != null) {
        listOfPipelineNetwork = pipelineNetworkModel.data!;
        for (int i = 0; i < listOfPipelineNetwork.length; i++) {
          latLngGis = await DecodePolyline.decodePolyline(
              listOfPipelineNetwork[i].geomencode!);
          if (tfGisController.text.isNotEmpty) {
            final Uint8List tfIcon =
                await ReportAlertHelper.getBytesFromAsset(AssetPath.tf, 50);
            tfMarkersPointList.addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.fromBytes(tfIcon),
            ));

            tfPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.yellow.shade900,
                latlngList: latLngGis,
                context: context));
            markersPointList.addAll(tfMarkersPointList);
            polylineList.addAll(tfPolylineList);
          } else if (gasValveGISController.text.isNotEmpty) {
            final Uint8List valveIcon =
                await ReportAlertHelper.getBytesFromAsset(AssetPath.valve, 50);
            valveMarkersPointList.addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.fromBytes(valveIcon),
            ));
            valvePolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.purpleAccent,
                latlngList: latLngGis,
                context: context));
            markersPointList.addAll(valveMarkersPointList);
            polylineList.addAll(valvePolylineList);
          } else if (gasRegulatorGISController.text.isNotEmpty) {
            final Uint8List regulatorIcon =
                await ReportAlertHelper.getBytesFromAsset(
                    AssetPath.regulator, 50);
            regulatorMarkersPointList
                .addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.fromBytes(regulatorIcon),
            ));
            regulatorPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.yellowAccent.shade400,
                latlngList: latLngGis,
                context: context));
            markersPointList.addAll(regulatorMarkersPointList);
            polylineList.addAll(regulatorPolylineList);
          } else if (gasRegulatorGISController.text.isNotEmpty) {
            regulatorMarkersPointList
                .addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            regulatorPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(regulatorMarkersPointList);
            polylineList.addAll(regulatorPolylineList);
          } else if (gasTeeGISController.text.isNotEmpty) {
            teeMarkersPointList.addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            teePolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(teeMarkersPointList);
            polylineList.addAll(teePolylineList);
          } else if (gasElbowGISController.text.isNotEmpty) {
            elbowMarkersPointList.addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            elbowPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(elbowMarkersPointList);
            polylineList.addAll(elbowPolylineList);
          } else if (gasCouplerGISController.text.isNotEmpty) {
            couplerMarkersPointList
                .addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            couplerPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(couplerMarkersPointList);
            polylineList.addAll(couplerPolylineList);
          } else if (gasReducerGISController.text.isNotEmpty) {
            reducerMarkersPointList
                .addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            reducerPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(reducerMarkersPointList);
            polylineList.addAll(reducerPolylineList);
          } else if (gasEndCapGISController.text.isNotEmpty) {
            endCapMarkersPointList
                .addAll(await NavigateAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ));
            endCapPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
            markersPointList.addAll(endCapMarkersPointList);
            polylineList.addAll(endCapPolylineList);
          }
        }
      } else if (pipelineNetworkModel.data?.length == 0) {
        return Utils.errorSnackBar(msg: "No data Found", context: context);
      }
      GoogleMapController controller = await googleMapController.future;
      if (markersPointList.isNotEmpty) {
        currentPosition = LatLng(markersPointList.last.position.latitude,
            markersPointList.last.position.longitude);
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition, zoom: 14)));
      }
    }
  }*/

  Future<void> _fetchPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    // Clear existing markers and polylines
    await _clearMarkerPolylineField();

    // Fetch pipeline network data
    var res = await ReportAlertHelper.getPipelineNetworkApi(
      context: context,
      latitude: latitude,
      longitude: longitude,
    );

    if (res == null) return;
    pipelineNetworkModel = res;

    if (pipelineNetworkModel.data?.isEmpty ?? true) {
      return Utils.errorSnackBar(msg: "No data Found", context: context);
    }

    listOfPipelineNetwork = pipelineNetworkModel.data!;

    // Configuration mapping GIS controllers to their specific attributes
    final gisConfigs = [
      {
        'controller': tfGisController,
        'iconPath': AssetPath.tf,
        'iconSize': 50,
        'color': Colors.yellow.shade900,
        'markerList': tfMarkersPointList,
        'polylineList': tfPolylineList,
      },
      {
        'controller': gasValveGISController,
        'iconPath': AssetPath.valve,
        'iconSize': 50,
        'color': Colors.purpleAccent,
        'markerList': valveMarkersPointList,
        'polylineList': valvePolylineList,
      },
      {
        'controller': gasRegulatorGISController,
        'iconPath': AssetPath.regulator,
        'iconSize': 50,
        'color': Colors.yellowAccent.shade400,
        'markerList': regulatorMarkersPointList,
        'polylineList': regulatorPolylineList,
      },
      {
        'controller': gasTeeGISController,
        'iconPath': null,
        'iconSize': 50,
        'color': Colors.green,
        'markerList': teeMarkersPointList,
        'polylineList': teePolylineList,
      },
      // Add additional configurations here...
    ];

    // Process each pipeline network
    for (var network in listOfPipelineNetwork) {
      latLngGis = await DecodePolyline.decodePolyline(network.geomencode!);

      for (var config in gisConfigs) {
        var controller = config['controller'] as TextEditingController;
        if (controller.text.isNotEmpty) {
          await _processNetworkSegment(
            context: context,
            latLngList: latLngGis,
            iconPath: config['iconPath'] as String?,
            iconSize: config['iconSize'] as int,
            polylineColor: config['color'] as Color,
            markerList: config['markerList'] as Set<Marker>,
            polylineCoList: config['polylineList'] as Set<Polyline>,
          );
          break; // Stop after processing the first matching condition
        }
      }
    }

    // Animate camera to the last marker if available
    if (markersPointList.isNotEmpty) {
      GoogleMapController controller = await googleMapController.future;
      currentPosition = LatLng(
        markersPointList.last.position.latitude,
        markersPointList.last.position.longitude,
      );
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 14),
        ),
      );
    }
  }

  Future<void> _processNetworkSegment({
    required BuildContext context,
    required List<LatLng> latLngList,
    String? iconPath,
    required int iconSize,
    required Color polylineColor,
    required Set<Marker> markerList,
    required Set<Polyline> polylineCoList,
  }) async {
    // Create marker icon
    BitmapDescriptor markerIcon;
    if (iconPath != null) {
      final Uint8List iconBytes = await ReportAlertHelper.getBytesFromAsset(iconPath, iconSize);
      markerIcon = BitmapDescriptor.fromBytes(iconBytes);
    } else {
      markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }

    // Add markers
    var markers = await NavigateAlertHelper.createMarker(
      latlngList: latLngList,
      context: context,
      markerIcon: markerIcon,
    );
    markerList.addAll(markers);
    markersPointList.addAll(markers);

    // Add polylines
    var polylines = await ReportAlertHelper.createPolyLine(
      color: polylineColor,
      latlngList: latLngList,
      context: context,
    );
    polylineCoList.addAll(polylines);
    polylineList.addAll(polylines);
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
    /*listOfFilterTfGis = [];
    _clearMarkerPolylineField();
    tfGisController.text = event.tfGisId;
    if (tfGisController.text.isNotEmpty && gasValveGISController.text.isEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: tfGisController.text);
      for (var listData in listOfTfGis) {
        if (listData.id.toString() == event.tfGisId.toString()) {
          listOfFilterTfGis.add(listData);
        }
      }
      if (listOfFilterTfGis.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterTfGis[0].latitude!,
            longitude: listOfFilterTfGis[0].longitude!);
        isPipelineLoader = false;
        _eventCompleted(emit);
      }
    }*/
    // Clear previous state
    listOfFilterTfGis.clear();
    _clearMarkerPolylineField();
    tfGisController.text = event.tfGisId;

    // Validate input
    if (tfGisController.text.isNotEmpty && gasValveGISController.text.isEmpty) {
      // Store the selected TF GIS ID
      await SharedPref.setString(
        key: PrefsValue.assetTypeId,
        value: tfGisController.text,
      );

      // Filter the list of TF GIS
      listOfFilterTfGis = listOfTfGis
          .where((listData) => listData.id.toString() == event.tfGisId.toString())
          .toList();

      // Fetch pipeline network if filter results exist
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

  _selectRegulatorGISValue(SelectRegulatorGISValueEvent event, emit) async {
    listOfFilterGasRegulatorGIS = [];
    _clearMarkerPolylineField();
    gasRegulatorGISController.text = event.gasRegulatorGISId;
    if (gasRegulatorGISController.text.isNotEmpty) {
      await SharedPref.setString(
          key: PrefsValue.assetTypeId, value: gasRegulatorGISController.text);
      for (var listData in listOfGasValueGIS) {
        if (listData.id.toString() == event.gasRegulatorGISId.toString()) {
          listOfFilterGasRegulatorGIS.add(listData);
        }
      }
      if (listOfFilterGasRegulatorGIS.isNotEmpty) {
        isPipelineLoader = true;
        _eventCompleted(emit);
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasRegulatorGIS[0].latitude!,
            longitude: listOfFilterGasRegulatorGIS[0].longitude!);
      }
      isPipelineLoader = false;
      _eventCompleted(emit);
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

  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    final Uint8List pinIcon =
        await ReportAlertHelper.getBytesFromAsset(AssetPath.pin, 50);
    Set<Marker> tempMarker = Set.from(markersPointList);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        event.latLngOnTap.latitude, event.latLngOnTap.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      nameofLocation = '${place.thoroughfare}, ${place.subLocality}, ${place.administrativeArea}, ${place.locality}, ${place.country}';
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
    polylineList = {};
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
      polylineList: Set.of(polylineList),
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
