import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/getNearestPoint.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/presentation/widget/alert_dialog_widget.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/presentation/widget/report_pop_widget.dart';
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
  CameraPosition cameraPosition =
      CameraPosition(target: LatLng(0, 0), zoom: 12);

  _pageLoad(ReportAlertLoadEvent event, emit) async {
    emit(ReportAlertInitialState());
    isLoader = false;
    isPipelineLoader = false;
    checkBoxTf = false;
    checkBoxValve = false;
    isGasTfLoader = false;
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
    tfGisController.text = '';
    gasValveGISController.text = '';
    gasRegulatorGISController.text = '';
    gasTeeGISController.text = '';
    gasElbowGISController.text = '';
    gasCouplerGISController.text = '';
    gasReducerGISController.text = '';
    gasEndCapGISController.text = '';

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

    pipelineNetworkModel = GetPipelineNetworkModel();
    pipelineNetworkData = PipelineNetworkData();
    listOfPipelineNetwork = [];
    currentPosition = LatLng(0, 0);
    loginPosition = LatLng(0, 0);
    latLngOnTap = LatLng(0, 0);
    latLngGis = [];
    markersPointList = {};
    tfMarkersPointList = {};
    valveMarkersPointList = {};
    regulatorMarkersPointList = {};
    teeMarkersPointList = {};
    elbowMarkersPointList = {};
    couplerMarkersPointList = {};
    reducerMarkersPointList = {};
    endCapMarkersPointList = {};

    polylineList = {};
    tfPolylineList = {};
    valvePolylineList = {};
    regulatorPolylineList = {};
    teePolylineList = {};
    elbowPolylineList = {};
    couplerPolylineList = {};
    reducerPolylineList = {};
    endCapPolylineList = {};

    currentMapType = MapType.normal;
    cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 12);
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
    final Uint8List markerIcon = await ReportAlertHelper.getBytesFromAsset(
        'assets/icons/pipeMarker.png', 100);
    cameraPosition = CameraPosition(target: loginPosition, zoom: 12);
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

  _fetchPipelineNetworkApi(
      {required BuildContext context,
      required String latitude,
      required String longitude}) async {
    latLngGis = [];
    tfMarkersPointList = {};
    valveMarkersPointList = {};
    tfPolylineList = {};
    valvePolylineList = {};
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
            tfMarkersPointList.addAll(await ReportAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
            ));
            tfPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.pink, latlngList: latLngGis, context: context));
          } else if (gasValveGISController.text.isNotEmpty) {
            valveMarkersPointList.addAll(await ReportAlertHelper.createMarker(
              latlngList: latLngGis,
              context: context,
              markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ));

            valvePolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green, latlngList: latLngGis, context: context));
          }
        }
      } else if (pipelineNetworkModel.data?.length == 0) {
        //  return Utils.errorSnackBar(msg: "No data Found", context: context);
      }
    }
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _selectCurrentMarkerButton(SelectCurrentMarkerButtonEvent event, emit) async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    if (currentPoint != null) {
      currentPosition = LatLng(currentPoint.latitude, currentPoint.longitude);
      /* markersPointList.add(Marker(
        markerId: MarkerId("${currentPoint.latitude.toString()},${currentPoint.longitude.toString()}"),
        position: currentPosition,
        infoWindow: InfoWindow(
          title: 'You',
        ),
        icon: BitmapDescriptor.hueYellow,
      ));*/
    }
    _eventCompleted(emit);
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearTextField();
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
    listOfFilterTfGis = [];
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
      }
      markersPointList.addAll(tfMarkersPointList);
      polylineList.addAll(tfPolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event, emit) async {
    await  _clearTextField();
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
    gasValveGISController.text = event.gasValveGISId;
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
      }
      markersPointList.addAll(valveMarkersPointList);
      polylineList.addAll(valvePolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxRegulatorGis(SelectCheckBoxRegulatorGisEvent event, emit) async {
    await  _clearTextField();
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
    listOfFilterGasValueGIS = [];
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
      markersPointList.addAll(valveMarkersPointList);
      polylineList.addAll(valvePolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxTeeGis(SelectCheckBoxTeeGisEvent event, emit) async {
    await _clearTextField();
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
    listOfFilterGasValueGIS = [];
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
      markersPointList.addAll(teeMarkersPointList);
      polylineList.addAll(teePolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxElbowGis(SelectCheckBoxElbowGisEvent event, emit) async {
    await _clearTextField();
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
    listOfFilterGasValueGIS = [];
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
      markersPointList.addAll(elbowMarkersPointList);
      polylineList.addAll(elbowPolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxCouplerGis(SelectCheckBoxCouplerGisEvent event, emit) async {
    await _clearTextField();
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
    listOfFilterGasValueGIS = [];
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
      markersPointList.addAll(couplerMarkersPointList);
      polylineList.addAll(couplerPolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxReducerGis(SelectCheckBoxReducerGisEvent event, emit) async {
    await _clearTextField();
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
    listOfFilterGasValueGIS = [];
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
      markersPointList.addAll(reducerMarkersPointList);
      polylineList.addAll(reducerPolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectCheckBoxEndCapGis(SelectCheckBoxEndCapGisEvent event, emit) async {
    await _clearTextField();
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
      markersPointList.addAll(endCapMarkersPointList);
      polylineList.addAll(endCapPolylineList);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    Set<Marker> tempMarker = Set.from(markersPointList);
    for (var polyData in polylineList) {
      for (int i = 0; i < polyData.points.length - 1; i++) {
        final start = polyData.points[i];
        final end = polyData.points[i + 1];
        if (NearestPolylinePoint.isPointNearLine(
            event.latLngOnTap, start, end, 10)) {
          tempMarker.add(
            Marker(
              markerId: MarkerId('Pipeline'),
              position: event.latLngOnTap,
              infoWindow: InfoWindow(title: 'Pickup Point'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
              onTap: () async {
                await SharedPref.setString(
                    key: PrefsValue.markerLat,
                    value: event.latLngOnTap.latitude.toString());
                await SharedPref.setString(
                    key: PrefsValue.markerLong,
                    value: event.latLngOnTap.longitude.toString());
                showBottomSheet(context: event.context, builder: (BuildContext context){
                  return AlertDialogTwoBtnWidget();
                });
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

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    showDialog(
        context: event.context,
        builder: (BuildContext context) {
          return ReportPopWidget(mContext: event.context,);
        });
    _eventCompleted(emit);
  }

  _clearTextField(){
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
  }
  _clearPopTextField(){
    tfGisController.text = "";
    gasValveGISController.text = "";
    gasRegulatorGISController.text = "";
    gasTeeGISController.text = "";
    gasElbowGISController.text = "";
    gasCouplerGISController.text = "";
    gasReducerGISController.text = "";
    gasEndCapGISController.text = "";
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
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      nameofLocation: nameofLocation,
      role: role,
      cameraPosition: cameraPosition,
      currentMapType: currentMapType,
      markersPointList: markersPointList,
      currentPosition: currentPosition,
      loginPosition: loginPosition,
      polylineList: polylineList,
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
      listOfTfGisId: listOfTfGisId,
      listOfGasValveGISId: listOfGasValveGISId,
      listOfGasRegulatorGISId: listOfGasRegulatorGISId,
      listOfGasTeeGISId: listOfGasTeeGISId,
      listOfGasElbowGISId: listOfGasElbowGISId,
      listOfGasCouplerGISId: listOfGasCouplerGISId,
      listOfGasReducerGISId: listOfGasReducerGISId,
      listOfGasEndCapGISId: listOfGasEndCapGISId,
    ));
  }
}
