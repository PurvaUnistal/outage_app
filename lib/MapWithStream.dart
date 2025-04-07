import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'features/ReportOutage/ReportOutageAlert/helper/decodePolyline.dart';

class DynamicPolylineMap extends StatefulWidget {
  @override
  _DynamicPolylineMapState createState() => _DynamicPolylineMapState();
}

class _DynamicPolylineMapState extends State<DynamicPolylineMap> {
  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getData();
  }

  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String loginLat = '';
  String loginLong = '';
  LatLng currentPosition = LatLng(0, 0);
  LatLng loginPosition = LatLng(0, 0);

  _getData() async {
    loginLat=  await  SharedPref.getString(key: PrefsValue.loginLat);
    loginLong = await SharedPref.getString(key: PrefsValue.loginLong);
    double? lat = double.tryParse(loginLat ?? '');
    double? long = double.tryParse(loginLong ?? '');

    if (lat != null && long != null) {
      loginPosition = LatLng(lat, long);
    } else {
      print(
          "Invalid latitude or longitude: loginLat = $loginLat, loginLong = $loginLong");
    }
    List<dynamic> results = await Future.wait([
      SharedPref.getString(key: PrefsValue.schema),
      SharedPref.getString(key: PrefsValue.userRole),
      SharedPref.getString(key: PrefsValue.userName),
      SharedPref.getString(key: PrefsValue.baseUrl),
      _fetchGasPipelineGisApi(),
    ]);

    scheme = (results[0] as String?) ?? "";
    role = (results[1] as String?) ?? "";
    userName = (results[2] as String?) ?? "";
    baseUrl = (results[3] as String?) ?? "";



  }

  PipelineModel pipelineModel = PipelineModel();
  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];
  List<LatLng> allLatLongPoint = [];

  Set<Polyline> polylinePointList = {};
  Set<Polyline> pipePolylinePointList = {};

  _fetchGasPipelineGisApi() async {
    var res = await ReportAlertHelper.getPipelineApi(
      context: context,
      latitude: loginPosition.latitude.toString(),
      longitude: loginPosition.longitude.toString(),
    );

    if (res != null) {
      setState(() {
        pipelineModel = res;
      });

      if (pipelineModel.data != null) {
        listOfPipeline = pipelineModel.data!;
      /* *//* for (int i = 0; i <= 1000 && i < listOfPipeline.length; i++) {
          final colors = ReportAlertHelper.getPolylineColor(
              int.tryParse(listOfPipeline[i].nominaldia!) ?? 0);

          // Await the decoding of polyline and the creation of polyline in separate async methods
         allLatLongPoint = await DecodePolyline.decodePolyline(
              listOfPipeline[i].geomencode!);
          var listOfPolyline = await ReportAlertHelper.createPolyLine(
              color: colors, latlngList: allLatLongPoint, context: context);
          setState(() {
            pipePolylinePointList.addAll(listOfPolyline);
            polylinePointList = pipePolylinePointList;
            currentPosition =
                LatLng(allLatLongPoint[0].latitude, allLatLongPoint[0].longitude);
            cameraPosition = CameraPosition(target: currentPosition, zoom: 14);

          });

          print("currentPosition-->${cameraPosition}");
        }*//*
        for (int i = 0; i <= 1000 && i < listOfPipeline.length; i+= 500) {

         allLatLongPoint = await DecodePolyline.decodePolyline(
              listOfPipeline[i].geomencode!);
          var listOfPolyline = await ReportAlertHelper.createPolyLine(
              color: Colors.red, latlngList: allLatLongPoint, context: context);
          setState(() {
            pipePolylinePointList.addAll(listOfPolyline);
            polylinePointList = pipePolylinePointList;
            currentPosition =
                LatLng(allLatLongPoint[0].latitude, allLatLongPoint[0].longitude);
            cameraPosition = CameraPosition(target: currentPosition, zoom: 14);

          });

          print("currentPosition-->${cameraPosition}");
        }*/
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Location in Google Maps")),
      body: polylinePointList.isNotEmpty ? GoogleMap(
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
      //  polylines: polylinePointList,
        onCameraMove: (CameraPosition position) {
          // Optionally handle camera position change if needed
        },
      ) : Center(child: CircularProgressIndicator())

    );
  }
}
