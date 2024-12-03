import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'features/Navigate/NavigateAlert/presentation/widget/search_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColor.primer));
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => LoginBloc()),
          BlocProvider(create: (BuildContext context) => HomeBloc()),
          BlocProvider(create: (BuildContext context) => ManageAlertBloc()),
          BlocProvider(create: (BuildContext context) => CreateAlertFormBloc()),
          BlocProvider(
              create: (BuildContext context) => MaintenanceAlertBloc()),
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
       //  home: MapScreen (),
           initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}




class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  LatLng _start = LatLng(37.7749, -122.4194); // San Francisco
  LatLng _end = LatLng(34.0522, -118.2437); // Los Angeles

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final String apiKey = 'AIzaSyAGSC08nb7Cq2mSVqaZWNVX4cIPdUSONps';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_start.latitude},${_start.longitude}&destination=${_end.latitude},${_end.longitude}&key=$apiKey';
print("url--->${url}");
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points = data['routes'][0]['overview_polyline']['points'];
        final List<LatLng> polylineCoordinates = _decodePolyline(points);

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print(e);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> coordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Between Two Places"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _start,
          zoom: 6,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        polylines: _polylines,
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: _start,
            infoWindow: InfoWindow(title: 'Start'),
          ),
          Marker(
            markerId: MarkerId('end'),
            position: _end,
            infoWindow: InfoWindow(title: 'End'),
          ),
        },
      ),
    );
  }
}
