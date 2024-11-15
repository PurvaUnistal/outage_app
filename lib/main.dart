import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:igl_outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_bloc.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'Utils/common_widgets/Routes/routes.dart';
import 'Utils/common_widgets/Routes/routes_name.dart';
import 'features/ManageOutage/ManageAlert/domain/bloc/manage_alert_bloc.dart';
import 'features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
  await HiveDataBase().init();
  await ReportAlertHelper.clearCache();
  await Future.delayed(Duration(seconds: 1));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppColor.primer));
    return MultiBlocProvider (
        providers: [
          BlocProvider(create: (BuildContext context) => LoginBloc()),
          BlocProvider(create: (BuildContext context) => HomeBloc()),
          BlocProvider(create: (BuildContext context) => ManageAlertBloc()),
          BlocProvider(create: (BuildContext context) => CreateAlertFormBloc()),
          BlocProvider(create: (BuildContext context) => MaintenanceAlertBloc()),
          BlocProvider(create: (BuildContext context) => NavigateAlertBloc()),
          BlocProvider(create: (BuildContext context) => ReportAlertBloc()),
          BlocProvider(create: (BuildContext context) => ReportDetailsBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColor.primer,
            hintColor: AppColor.primer,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.primer,
            ),
          ),
        //  home: PolylineClickExample(),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}


class PolylineClickExample extends StatefulWidget {
  @override
  _PolylineClickExampleState createState() => _PolylineClickExampleState();
}

class _PolylineClickExampleState extends State<PolylineClickExample> {
  late GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.43061033082363, -122.088497749281),
    LatLng(37.43296265331129, -122.091589879415),
  ];

  @override
  void initState() {
    super.initState();
    _addPolyline();
  }

  void _addPolyline() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId('test_polyline'),
        points: polylineCoordinates,
        width: 5,
        color: Colors.blue,
      ),
    );
  }

  void _onMapTapped(LatLng tappedPoint) {
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      final start = polylineCoordinates[i];
      final end = polylineCoordinates[i + 1];

      if (_isPointNearLine(tappedPoint, start, end, 10.0)) { // 10 meters threshold
        print("Polyline clicked!");
        // Perform actions when polyline is clicked
        break;
      }
    }
  }

  bool _isPointNearLine(LatLng point, LatLng start, LatLng end, double threshold) {
    double distance = _distanceFromPointToLine(point, start, end);
    return distance < threshold;
  }

  double _distanceFromPointToLine(LatLng point, LatLng start, LatLng end) {
    // Calculate the distance from `point` to the line segment `start`-`end`.
    final double A = point.latitude - start.latitude;
    final double B = point.longitude - start.longitude;
    final double C = end.latitude - start.latitude;
    final double D = end.longitude - start.longitude;

    final double dot = A * C + B * D;
    final double len_sq = C * C + D * D;
    final double param = len_sq != 0 ? dot / len_sq : -1;

    double xx, yy;

    if (param < 0) {
      xx = start.latitude;
      yy = start.longitude;
    } else if (param > 1) {
      xx = end.latitude;
      yy = end.longitude;
    } else {
      xx = start.latitude + param * C;
      yy = start.longitude + param * D;
    }

    final double dx = point.latitude - xx;
    final double dy = point.longitude - yy;
    return sqrt(dx * dx + dy * dy) * 111320; // Convert to meters
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polyline Click Example')),
      body: GoogleMap(
        onMapCreated: (controller) => _controller = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 15,
        ),
        polylines: _polylines,
        onTap: _onMapTapped,
      ),
    );
  }
}


