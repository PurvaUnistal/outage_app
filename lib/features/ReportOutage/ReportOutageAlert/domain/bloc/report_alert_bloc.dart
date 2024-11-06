import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/presentation/maintenance_alert_page.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'report_alert_event.dart';
import 'report_alert_state.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:collection/collection.dart';
class ReportAlertBloc extends Bloc<ReportAlertEvent, ReportAlertState> {
  ReportAlertBloc() : super(ReportAlertInitialState()) {
    on<ReportAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectCurrentMarkerButtonEvent>(_selectCurrentMarkerButton);
    on<SelectCameraPositionButtonEvent>(_selectCameraPositionButton);
    on<SelectTFGisEvent>(_selectTFGisValue);
    on<SelectValveGISValueEvent>(_selectValveGISValue);

  }
  bool isLoader =  false;
  bool isPipelineLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String loginLat = '';
  String loginLong = '';
  String nameofLocation = '';

  TextEditingController tfGisController  = TextEditingController();
  TextEditingController gasValveGISController  = TextEditingController();

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
  Set<Polyline> polylineList = {};

  List<LatLng> pipeLatLngPoint = [];
  MapType currentMapType = MapType.normal;


  List<String> _selectedItems = [];

  List<String> items = [
    'TF',
    'Valve',
    'MRS',
    'DRS',
    'FRS',
    'TFR'
  ];
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
    isLoader =  false;
    isPipelineLoader =  false;
    role = '';
    nameofLocation = '';
    tfGisController.text  = '';
    gasValveGISController.text  = '';
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
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    loginLat = await SharedPref.getString(key: PrefsValue.loginLat);
    loginLong = await SharedPref.getString(key: PrefsValue.loginLong);
    loginPosition = LatLng(double.parse(loginLat.toString()), double.parse(loginLong.toString()));

    List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(loginLat.toString()), double.parse(loginLong.toString()));
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      nameofLocation = '${place.locality}, (${place.country})';
    }
    await addLoginMarkerGISPoint();
    await fetchTFGisApi(context: event.context);
    await fetchGasValueGisApi(context:event.context);
    _eventCompleted(emit);
  }

  addLoginMarkerGISPoint() async {
    print("loginLat-->"+loginLat);
    print("loginLong-->"+loginLong);
    final Uint8List markerIcon = await ReportAlertHelper.getBytesFromAsset('assets/icons/pipeMarker.png', 100);
    markersPointList .add(Marker(
      markerId: MarkerId("Hello"),
      position: loginPosition,
      icon:  BitmapDescriptor.defaultMarker,
      // icon: BitmapDescriptor.fromBytes(markerIcon),
    ));


  }

  fetchPipelineApi({required BuildContext context,}) async {
    var res = await ReportAlertHelper.getPipelineGisApi(context: context,);
    if (res != null) {
      gasPipelineModel = res;
      if(gasPipelineModel.data != null){
        listOfPipelineGIS = gasPipelineModel.data!;
        pipeLatLngPoint = [];
        List<dynamic> list = listOfPipelineGIS.map((e) => e.geomtext.toString().replaceAll("LINESTRING(", "").toString().replaceAll(")", "")).toList();
        for(var listData in list){
          List<dynamic> data =  listData.toString().split(",");
          for(var _data in data){
            List<dynamic> latLongData = _data.toString().split(" ");
            if(latLongData.isNotEmpty){
              pipeLatLngPoint.add(LatLng(double.parse(latLongData[1]), double.parse(latLongData[0])));
            }
          }
        }
        drawPipePolyLinesList();
      }
      return res;
    }
  }

  drawPipePolyLinesList() async {
    polylineList.add(Polyline(
      polylineId: PolylineId("Hello"),
      visible: true,
      width: 8,
      points: pipeLatLngPoint,
      color: Colors.red, //color of polyline
    ));
  }


  addMarkerGISPoint() async {
    final Uint8List markerIcon = await ReportAlertHelper.getBytesFromAsset('assets/icons/pipeMarker.png', 100);
    if(listOfGasValueGIS.isNotEmpty){
      for(int i = 0; i < listOfGasValueGIS.length; i++){
        markersPointList .add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              double.parse(listOfGasValueGIS[i].longitude.toString()),
              double.parse(listOfGasValueGIS[i].latitude.toString())),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
      }
    }
  }

  fetchFittingGisApi({required BuildContext context,}) async {
    var res = await ReportAlertHelper.getFittingGisApi(context: context,);
    if (res != null) {
      fittingGISModel = res;
      if(fittingGISModel.data != null){
        listOfFittingGIS = fittingGISModel.data!;
        if(listOfFittingGIS.isNotEmpty){
          for(int i = 0; i < listOfFittingGIS.length; i++){
            markersPointList .add(Marker(
                markerId: MarkerId(i.toString()),
                infoWindow: InfoWindow(title: listOfFittingGIS[i].geomtext,),
                position: LatLng(
                    double.parse(listOfFittingGIS[i].longitude.toString()),
                    double.parse(listOfFittingGIS[i].latitude.toString())),

                icon: BitmapDescriptor.defaultMarker
            ));
          }
        }
        return res;
      }
    }
  }
  fetchGasValueGisApi({required BuildContext context,}) async {
    var res = await ReportAlertHelper.getGasValueGisApi(context: context,);
    if (res != null) {
      gasValueGISModel = res;
      if(gasValueGISModel.data != null){
        listOfGasValueGIS = gasValueGISModel.data!;
        listOfGasValveGISId = listOfGasValueGIS.map((e) => e.id!).toList();
        return res;
      }
    }
  }
  fetchTFGisApi({required BuildContext context,}) async {
    var res = await ReportAlertHelper.getTFGisApi(context: context,);
    if (res != null) {
      tfGisModel = res;
      if(tfGisModel.data != null){
        listOfTfGis = tfGisModel.data!;
        listOfTfGisId = listOfTfGis.map((e) => e.id!).toList();
        return res;
      }
    }
  }

  fetchPipelineNetworkApi({required BuildContext context,required String latitude, required String longitude}) async {
    var res = await ReportAlertHelper.getPipelineNetworkApi(
      context: context,
      latitude: latitude,
      longitude: longitude,
    );
    if (res != null) {
      pipelineNetworkModel = res;
      if(pipelineNetworkModel.data != null){
        listOfPipelineNetwork = pipelineNetworkModel.data!;
        for(int i = 0; i < listOfPipelineNetwork.length; i++){
          decodePolyline(listOfPipelineNetwork[i].geomencode!,context);
        }
      }
    }
  }

  void decodePolyline(String encodedPolyline, BuildContext context) {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(encodedPolyline);
    for (int i = 0; i <points.length; i++ ) {
      polylineCoordinates.add(LatLng(points[i].latitude, points[i].longitude));
    }
    if(polylineCoordinates.isNotEmpty){
      log("polylineCoordinates${polylineCoordinates}");
      polylineList.add(Polyline(
          polylineId: PolylineId(points.toString()),
          visible: true,
          width: 2,
          points: polylineCoordinates,
          color: Colors.green,
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaintenanceAlertView()));
          }
      ));
    }
    if(polylineCoordinates.isNotEmpty){
      for(int i = 0; i < polylineCoordinates.length; i++){
        markersPointList .add(Marker(
            markerId: MarkerId(i.toString()),
            infoWindow: InfoWindow(title: polylineCoordinates[i].latitude.toString(),),
            position: LatLng(points[i].latitude, points[i].longitude),
            icon: BitmapDescriptor.defaultMarker,
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaintenanceAlertView()));
            }
        ));
      }
    }
  }

  getCurrentPosition() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    currentPosition = LatLng(currentPoint!.latitude, currentPoint.longitude);
    log("currentPosition-->${currentPosition.longitude} latitude-->${currentPosition.latitude}");
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _selectCurrentMarkerButton(SelectCurrentMarkerButtonEvent event,  emit) async {
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

  _selectCameraPositionButton(SelectCameraPositionButtonEvent event, emit) {
  }

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    polylineList = {};
    tfGisController.text = event.tfGisId;
    if(listOfTfGis.firstWhereOrNull((element) => element.id == event.tfGisId)?.id != null){
      isPipelineLoader = true;
      _eventCompleted(emit);
      listOfFilterTfGis = listOfTfGis.where((element) => element.id.toString().contains(event.tfGisId)).toList();
      await fetchPipelineNetworkApi(context: event.context, latitude: listOfFilterTfGis[0].latitude!, longitude: listOfFilterTfGis[0].longitude!);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }
  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    polylineList = {};
    gasValveGISController.text = event.gasValveGISId;
    if(listOfTfGis.firstWhereOrNull((element) => element.id == event.gasValveGISId)?.id != null){
      isPipelineLoader = true;
      _eventCompleted(emit);
      listOfFilterGasValueGIS = listOfTfGis.where((element) => element.id.toString().contains(event.gasValveGISId)).toList();
      await fetchPipelineNetworkApi(context: event.context, latitude: listOfFilterGasValueGIS[0].latitude!, longitude: listOfFilterGasValueGIS[0].longitude!);
      isPipelineLoader = false;
      _eventCompleted(emit);
    }
  }
  _eventCompleted(Emitter<ReportAlertState> emit) {
    emit(FetchReportAlertDataState(
      isLoader: isLoader,
      isPipelineLoader: isPipelineLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      nameofLocation: nameofLocation,
      role: role,
      tfGisController: tfGisController,
      gasValveGISController: gasValveGISController,
      listOfTfGisId: listOfTfGisId,
      currentMapType: currentMapType,
      markersPointList: markersPointList,
      currentPosition: currentPosition,
      loginPosition: loginPosition,
      polylineList: polylineList,
      tfGisModel : tfGisModel,
      listOfTfGis : listOfTfGis,
      pipelineNetworkModel : pipelineNetworkModel,
      pipelineNetworkData : pipelineNetworkData,
      listOfPipelineNetwork : listOfPipelineNetwork,
      listOfGasValveGISId : listOfGasValveGISId,
      listOfGasValueGIS : listOfGasValueGIS,
    ));
  }

}
