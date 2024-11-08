import 'dart:developer';
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
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';

import 'report_alert_event.dart';
import 'report_alert_state.dart';

class ReportAlertBloc extends Bloc<ReportAlertEvent, ReportAlertState> {
  ReportAlertBloc() : super(ReportAlertInitialState()) {
    on<ReportAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectCurrentMarkerButtonEvent>(_selectCurrentMarkerButton);
    on<SelectCameraPositionButtonEvent>(_selectCameraPositionButton);
    on<SelectTFGisEvent>(_selectTFGisValue);
    on<SelectCheckBoxTFGisEvent>(_selectCheckBoxTFGis);
    on<SelectValveGISValueEvent>(_selectValveGISValue);
    on<SelectCheckBoxValveGisEvent>(_selectCheckBoxValveGis);
  }

  bool isLoader = false;
  bool isPipelineLoader = false;
  bool checkBoxTf = false;
  bool checkBoxValve = false;
  bool isGasTfLoader = false;
  bool isGasValveLoader = false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String loginLat = '';
  String loginLong = '';
  String nameofLocation = '';

  TextEditingController tfGisController = TextEditingController();
  TextEditingController gasValveGISController = TextEditingController();
  GoogleMapController? googleMapController;

  GetPipelineGisModel gasPipelineModel = GetPipelineGisModel();
  List<GetPipelineGisData> listOfPipelineGIS = [];

  GetTfGisModel gasValueGISModel = GetTfGisModel();
  List<TfGisData> listOfGasValueGIS = [];
  List<TfGisData> listOfFilterGasValueGIS = [];
  List<String> listOfGasValveGISId = [];

  GetGasValueGISModel fittingGISModel = GetGasValueGISModel();
  List<GetGasValueGISData> listOfFittingGIS = [];

  GetTfGisModel tfGisModel = GetTfGisModel();
  List<TfGisData> listOfTfGis = [];
  List<TfGisData> listOfFilterTfGis = [];
  List<String> listOfTfGisId = [];

  GetPipelineNetworkModel pipelineNetworkModel = GetPipelineNetworkModel();
  PipelineNetworkData pipelineNetworkData = PipelineNetworkData();
  List<PipelineNetworkData> listOfPipelineNetwork = [];

  LatLng currentPosition = LatLng(0, 0);
  LatLng loginPosition = LatLng(0, 0);
  Set<Marker> markersPointList = {};
  Set<Marker> valveMarkersPointList = {};
  Set<Marker> tfMarkersPointList = {};
  Set<Polyline> polylineList = {};
  Set<Polyline> tfPolylineList = {};
  Set<Polyline> valvePolylineList = {};

  List<LatLng> pipeLatLngPoint = [];
  MapType currentMapType = MapType.normal;



  List<String> _selectedItems = [];

  List<String> items = ['TF', 'Valve', 'MRS', 'DRS', 'FRS', 'TFR'];
  List<IconData> iconList = [
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
  ];
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.pink,
    Colors.yellow,
    Colors.blue.shade900,
    Colors.cyanAccent,
  ];



  _pageLoad(ReportAlertLoadEvent event, emit) async {
    emit(ReportAlertInitialState());
    isLoader = false;
    isPipelineLoader = false;
    checkBoxTf = false;
    checkBoxValve = false;
    isGasTfLoader = false;
    isGasValveLoader = false;
    role = '';
    nameofLocation = '';
    tfGisController.text = '';
    gasValveGISController.text = '';
    googleMapController = null;
    gasPipelineModel = GetPipelineGisModel();
    listOfPipelineGIS = [];
    gasValueGISModel = GetTfGisModel();
    listOfGasValueGIS = [];
    listOfGasValveGISId = [];
    fittingGISModel = GetGasValueGISModel();
    listOfFittingGIS = [];
    tfGisModel = GetTfGisModel();
    listOfTfGis = [];
    listOfFilterTfGis = [];
    listOfFilterGasValueGIS = [];
    listOfTfGisId = [];
    pipelineNetworkModel = GetPipelineNetworkModel();
    pipelineNetworkData = PipelineNetworkData();
    listOfPipelineNetwork = [];
    currentPosition = LatLng(0, 0);
    loginPosition = LatLng(0, 0);
    markersPointList = {};
    polylineList = {};
    pipeLatLngPoint = [];

    currentMapType = MapType.normal;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    print("scheme-->${scheme}");
    print("role-->${role}");
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    loginLat = await SharedPref.getString(key: PrefsValue.loginLat);
    loginLong = await SharedPref.getString(key: PrefsValue.loginLong);
    loginPosition = LatLng(
        double.parse(loginLat.toString()), double.parse(loginLong.toString()));
    await ReportAlertHelper.clearCache();
    await _currentAdd();
    await _addLoginMarkerGISPoint();
    _eventCompleted(emit);
  }

  _currentAdd() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(loginLat.toString()), double.parse(loginLong.toString()));
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      nameofLocation = '${place.locality}, (${place.country})';
    }
  }

  _addLoginMarkerGISPoint() async {
    print("loginLat-->" + loginLat);
    print("loginLong-->" + loginLong);
    final Uint8List markerIcon = await ReportAlertHelper.getBytesFromAsset(
        'assets/icons/pipeMarker.png', 100);
    markersPointList.add(Marker(
      markerId: MarkerId(nameofLocation),
      position: loginPosition,
      icon: BitmapDescriptor.defaultMarker,
      // icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
  }

  _fetchPipelineApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getPipelineGisApi(
      context: context,
    );
    if (res != null) {
      gasPipelineModel = res;
      if (gasPipelineModel.data != null) {
        listOfPipelineGIS = gasPipelineModel.data!;
        pipeLatLngPoint = [];
        List<dynamic> list = listOfPipelineGIS
            .map((e) => e.geomtext
                .toString()
                .replaceAll("LINESTRING(", "")
                .toString()
                .replaceAll(")", ""))
            .toList();
        for (var listData in list) {
          List<dynamic> data = listData.toString().split(",");
          for (var _data in data) {
            List<dynamic> latLongData = _data.toString().split(" ");
            if (latLongData.isNotEmpty) {
              pipeLatLngPoint.add(LatLng(
                  double.parse(latLongData[1]), double.parse(latLongData[0])));
            }
          }
        }
        polylineList.add(Polyline(
          polylineId: PolylineId("Hello"),
          visible: true,
          width: 8,
          points: pipeLatLngPoint,
          color: Colors.red, //color of polyline
        ));
      }
      return res;
    }
  }

  _fetchFittingGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getFittingGisApi(
      context: context,
    );
    if (res != null) {
      fittingGISModel = res;
      if (fittingGISModel.data != null) {
        listOfFittingGIS = fittingGISModel.data!;
        if (listOfFittingGIS.isNotEmpty) {
          for (int i = 0; i < listOfFittingGIS.length; i++) {
            markersPointList.add(Marker(
                markerId: MarkerId(i.toString()),
                infoWindow: InfoWindow(
                  title: listOfFittingGIS[i].geomtext,
                ),
                position: LatLng(
                    double.parse(listOfFittingGIS[i].longitude.toString()),
                    double.parse(listOfFittingGIS[i].latitude.toString())),
                icon: BitmapDescriptor.defaultMarker));
          }
        }
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

  _fetchPipelineNetworkApi(
      {required BuildContext context,
      required String latitude,
      required String longitude}) async {
    await ReportAlertHelper.clearCache();
    var res = await ReportAlertHelper.getPipelineNetworkApi(
      context: context,
      latitude: latitude,
      longitude: longitude,
    );
    if (res != null) {
      pipelineNetworkModel = res;
      if (pipelineNetworkModel.data != null) {
        listOfPipelineNetwork = pipelineNetworkModel.data!;
        for (int i = 0; i < listOfPipelineNetwork.length; i++) {
          if (tfGisController.text.isNotEmpty) {
            tfMarkersPointList.addAll(await ReportAlertHelper.createMarker(
                latlngList: DecodePolyline.decodePolyline(
                    listOfPipelineNetwork[i].geomencode!),
                context: context,
                markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan),
                ));
            tfPolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.cyanAccent,
                latlngList: DecodePolyline.decodePolyline(
                    listOfPipelineNetwork[i].geomencode!),
                context: context));
          } else if (gasValveGISController.text.isNotEmpty) {
            print(i);
            valveMarkersPointList.addAll(await ReportAlertHelper.createMarker(
                latlngList: DecodePolyline.decodePolyline(
                    listOfPipelineNetwork[i].geomencode!),
                context: context,
                markerIcon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                ));
            valvePolylineList.addAll(await ReportAlertHelper.createPolyLine(
                color: Colors.green,
                latlngList: DecodePolyline.decodePolyline(
                    listOfPipelineNetwork[i].geomencode!),
                context: context));
          }
        }
      }
    }
  }

  getCurrentPosition() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    currentPosition = LatLng(currentPoint!.latitude, currentPoint.longitude);
    log("currentPosition-->${currentPosition.longitude} latitude-->${currentPosition.latitude}");
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _selectCurrentMarkerButton(SelectCurrentMarkerButtonEvent event, emit) async {
    await getCurrentPosition();
    markersPointList.add(Marker(
      markerId: MarkerId("hello"),
      position: currentPosition,
      infoWindow: InfoWindow(
        title: 'You',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _eventCompleted(emit);
  }

  _selectCameraPositionButton(SelectCameraPositionButtonEvent event, emit) {}

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event,emit) async {
    checkBoxTf = event.checkBoxTf;
    isGasTfLoader = true;
    _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context);
      await SharedPref.setString(key: PrefsValue.tfAssetId,value: tfGisModel.assetId!);
    isGasTfLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event,emit) async {
    checkBoxTf = false;
    checkBoxValve = event.checkBoxValve;
    isGasValveLoader = true;
    _eventCompleted(emit);
    await _fetchGasValueGisApi(context: event.context);
  //  await SharedPref.setString(key: PrefsValue.tfAssetId,value: tfGisModel.assetId!);
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    polylineList = {};
    markersPointList = {};
    tfMarkersPointList = {};
    tfGisController.text = event.tfGisId;
    if(tfGisController.text.isNotEmpty && gasValveGISController.text.isEmpty){
      await SharedPref.remove(key: PrefsValue.gasValveGISId);
      await SharedPref.setString(key: PrefsValue.tfGisId,value: tfGisController.text);
      listOfFilterTfGis = [];
      tfPolylineList = {};
      isPipelineLoader = true;
      _eventCompleted(emit);
      for (var listData in listOfTfGis) {
        if (listData.id.toString() == event.tfGisId.toString()) {
          listOfFilterTfGis.add(listData);
        }
      }
      if (listOfFilterTfGis.isNotEmpty) {
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterTfGis[0].latitude!,
            longitude: listOfFilterTfGis[0].longitude!);
        isPipelineLoader = false;
      }

      markersPointList.addAll(tfMarkersPointList);
 //     markersPointList.addAll(valveMarkersPointList);
      polylineList.addAll(tfPolylineList);
  //    polylineList.addAll(valvePolylineList);
      _eventCompleted(emit);
    }
  }

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    polylineList = {};
    markersPointList = {};
    valveMarkersPointList = {};
    gasValveGISController.text = event.gasValveGISId;
    if(gasValveGISController.text.isNotEmpty && tfGisController.text.isEmpty){
      await SharedPref.remove(key: PrefsValue.tfGisId);
      await SharedPref.setString(key: PrefsValue.gasValveGISId,value: gasValveGISController.text);
      listOfFilterGasValueGIS = [];
      valvePolylineList = {};
      isPipelineLoader = true;
      _eventCompleted(emit);
      for (var listData in listOfTfGis) {
        if (listData.id.toString() == event.gasValveGISId.toString()) {
          listOfFilterGasValueGIS.add(listData);
        }
      }
      if (listOfFilterGasValueGIS.isNotEmpty) {
        await _fetchPipelineNetworkApi(
            context: event.context,
            latitude: listOfFilterGasValueGIS[0].latitude!,
            longitude: listOfFilterGasValueGIS[0].longitude!);
        isPipelineLoader = false;
      }
   //   markersPointList.addAll(tfMarkersPointList);
      markersPointList.addAll(valveMarkersPointList);
   //   polylineList.addAll(tfPolylineList);
      polylineList.addAll(valvePolylineList);
      _eventCompleted(emit);
    }
  }

  _eventCompleted(Emitter<ReportAlertState> emit) {
    emit(FetchReportAlertDataState(
      isLoader: isLoader,
      isPipelineLoader: isPipelineLoader,
      checkBoxTf: checkBoxTf,
      checkBoxValve: checkBoxValve,
      isGasTfLoader: isGasTfLoader,
      isGasValveLoader: isGasValveLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      nameofLocation: nameofLocation,
      role: role,
      googleMapController: googleMapController,
      tfGisController: tfGisController,
      gasValveGISController: gasValveGISController,
      listOfTfGisId: listOfTfGisId,
      currentMapType: currentMapType,
      markersPointList: markersPointList,
      currentPosition: currentPosition,
      loginPosition: loginPosition,
      polylineList: polylineList,
      tfGisModel: tfGisModel,
      listOfTfGis: listOfTfGis,
      pipelineNetworkModel: pipelineNetworkModel,
      pipelineNetworkData: pipelineNetworkData,
      listOfPipelineNetwork: listOfPipelineNetwork,
      listOfGasValveGISId: listOfGasValveGISId,
      listOfGasValueGIS: listOfGasValueGIS,
    ));
  }
}
