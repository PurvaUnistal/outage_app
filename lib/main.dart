import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

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
          // home: BlinkingMarkerMap(),
             initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}

class BlinkingMarkerMap extends StatefulWidget {
  @override
  _BlinkingMarkerMapState createState() => _BlinkingMarkerMapState();
}

class _BlinkingMarkerMapState extends State<BlinkingMarkerMap> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  late Timer _timer;
  bool _isVisible = true;

  final LatLng _markerPosition = LatLng(37.7749, -122.4194); // Example position

  @override
  void initState() {
    super.initState();
    _startBlinkingMarker();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBlinkingMarker() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _isVisible = !_isVisible;

        // Update the marker
        if (_isVisible) {
          _markers.add(
            Marker(
              markerId: MarkerId('blinking_marker'),
              position: _markerPosition,
              infoWindow: InfoWindow(title: 'Blinking Marker'),
            ),
          );
        } else {
          _markers.removeWhere((marker) => marker.markerId.value == 'blinking_marker');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blinking Marker'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markerPosition,
          zoom: 14,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
