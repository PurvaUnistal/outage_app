import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/incident_report_helper.dart';

class DynamicPolylineMap extends StatefulWidget {
  @override
  _DynamicPolylineMapState createState() => _DynamicPolylineMapState();
}

class _DynamicPolylineMapState extends State<DynamicPolylineMap> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  String loginLat = '';
  String loginLong = '';
  LatLng loginPosition = LatLng(0, 0);

  _getData() async {
    loginLat =
        await AppConfig.instanceInit()?.loginData.user?.gaLatitude! ?? "";
    loginLong =
        await AppConfig.instanceInit()?.loginData.user?.gaLongitude! ?? "";
    double? lat = double.tryParse(loginLat ?? '');
    double? long = double.tryParse(loginLong ?? '');
    if (lat != null && long != null) {
      loginPosition = LatLng(lat, long);
    } else {
      print(
          "Invalid latitude or longitude: loginLat = $loginLat, loginLong = $loginLong");
    }
    _fetchGasPipelineGisApi();
  }

  PipelineModel pipelineModel = PipelineModel();
  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];
  List<LatLng> allLatLongPoint = [];
  Set<Polyline> polylinePointList = {};
  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> finalPolylines = {};
  Set<Polyline> _polyline = {};
  final StreamController<Set<Polyline>> _polylineStreamController =
      StreamController<Set<Polyline>>();

  Stream<Set<Polyline>> get polylineStream => _polylineStreamController.stream;

  void updatePolylines(Set<Polyline> polylines) {
    setState(() {
      this._polyline = polylines;
    });
  }

  Completer<GoogleMapController> googleMapController = Completer();

  _fetchGasPipelineGisApi() async {
    var res = await IncidentReportHelper.getPipelineApi(
      context: context,
      latitude: loginPosition.latitude.toString(),
      longitude: loginPosition.longitude.toString(),
    );
    if (res != null && res.data != null) {
      pipelineModel = res;
      listOfPipeline = pipelineModel.data!;
      finalPolylines.clear();
      await gotoIntialPostion(loginPosition);
      updatePolylines(finalPolylines);

      for (int i = 0; i < listOfPipeline.length; i++) {
        final data = listOfPipeline[i];
        if (data.geomencode != null && data.geomencode!.isNotEmpty) {
          try {
            List<LatLng> points =
                await DecodePolyline.decodePolyline(data.geomencode!);

            Polyline polyline = Polyline(
              polylineId: PolylineId("polyline_$i"),
              points: points,
              color: Colors.green,
              width: 4,
            );
            finalPolylines.add(polyline);
            // abhi dos
          } catch (e) {
            print("Error decoding polyline at index $i: $e");
          }
        }
      }

      _filterVisiblePolylines();
    }
  }

  Future<void> gotoIntialPostion(LatLng location) async {
      CameraPosition position = CameraPosition(
        target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  bool isPointInBounds(LatLng point, LatLngBounds bounds) {
    final southwest = bounds.southwest;
    final northeast = bounds.northeast;
    return (point.latitude >= southwest.latitude &&
            point.latitude <= northeast.latitude) &&
        (point.longitude >= southwest.longitude &&
            point.longitude <= northeast.longitude);
  }

  Future<void> _filterVisiblePolylines() async {
    print("length ${finalPolylines.length}");
    final controller = await googleMapController.future;
    final bounds = await controller.getVisibleRegion();
    final visible = finalPolylines.where((polyline) {
      return polyline.points.any((point) => isPointInBounds(point, bounds));
    }).toSet();
    updatePolylines(visible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Current Location in Google Maps")),
        body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: loginPosition,
              zoom: AppString.zoom,
            ),
            rotateGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              googleMapController.complete(controller);
            },
            onCameraIdle: () async {
              _filterVisiblePolylines();
            },
            polylines: _polyline,
            minMaxZoomPreference: MinMaxZoomPreference(15, null)));
  }
}
