import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Timer? _debounce;
  final StreamController<Set<Polyline>> _polylineStreamController = StreamController.broadcast();
  Set<Polyline> _currentPolylines = {};
  List<PipelineData> listOfPipeline = []; // Replace with actual model

  @override
  void initState() {
    super.initState();
    _fetchGasPipelineGisApi();
  }

  /// API Call to Fetch Pipeline Data
  Future<void> _fetchGasPipelineGisApi() async {
    var res = await ReportAlertHelper.getPipelineApi(
      context: context,
      latitude: "",  // Pass dynamic values here
      longitude: "",
    );

    if (res != null && res.data != null) {
      listOfPipeline = res.data!;
      _updatePolylines(); // Load initial polylines
    }
  }

  /// Called when the user moves the map
  void _onCameraMove(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      _updatePolylines();
    });
  }

  /// Process and update polylines in smaller batches
  Future<void> _updatePolylines() async {
    Set<Polyline> newPolylines = {};

    // Process polylines in chunks asynchronously
    for (int i = 0; i < listOfPipeline.length; i += 500) {
      List<LatLng> polylineCoordinates = await compute(_decodePolyline, listOfPipeline[i].geomencode!);

      var polyline = await ReportAlertHelper.createPolyLine(
        color: Colors.pink,
        latlngList: polylineCoordinates,
        context: context,
      );

      newPolylines.addAll(polyline);
    }

    // Use `microtask` to update without blocking UI
    Future.microtask(() {
      _currentPolylines = newPolylines;
      _polylineStreamController.add(_currentPolylines);
    });
  }

  /// Decode polyline in a separate isolate
  static List<LatLng> _decodePolyline(String encoded) {
    return DecodePolyline.decodePolyline(encoded);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _polylineStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Set<Polyline>>(
        stream: _polylineStreamController.stream,
        builder: (context, snapshot) {
          return GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: _onCameraMove,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 10,
            ),
            polylines: snapshot.data ?? {},
          );
        },
      ),
    );
  }
}
