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
        //  home: GoogleMapPolylineSnapExample(),
             initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}

class GoogleMapPolylineSnapExample extends StatefulWidget {
  @override
  _GoogleMapPolylineSnapExampleState createState() =>
      _GoogleMapPolylineSnapExampleState();
}

class _GoogleMapPolylineSnapExampleState
    extends State<GoogleMapPolylineSnapExample> {
  late GoogleMapController _controller;
  final List<LatLng> _polylinePoints = [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.42866133580664, -122.089749655962),
    LatLng(37.42926133580664, -122.092749655962),
  ];
  Set<Polyline> _polylines = {};
  Set<Marker> _marker = {};
  LatLng? _closestPoint;

  @override
  void initState() {
    super.initState();
    _initPolyline();
  }

  void _initPolyline() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId('polyline_1'),
        points: _polylinePoints,
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  LatLng _findClosestPoint(LatLng tapPoint) {
    double minDistance = double.infinity;
    LatLng? closestPoint;

    for (int i = 0; i < _polylinePoints.length - 1; i++) {
      final segmentStart = _polylinePoints[i];
      final segmentEnd = _polylinePoints[i + 1];

      final snappedPoint =
          _getClosestPointOnSegment(segmentStart, segmentEnd, tapPoint);
      final distance = _calculateDistance(tapPoint, snappedPoint);
print("minDistance-->$minDistance");
print("distance-->$distance");
      if (distance < minDistance) {

        minDistance = distance;
        closestPoint = snappedPoint;
      }
    }
    setState(() {
      if (_closestPoint != null) {
        _marker.add(Marker(
          markerId: MarkerId('closest_point'),
          position: _closestPoint!,
          infoWindow: InfoWindow(title: 'Snapped Point'),
        ));
      }
    });
    return closestPoint!;
  }

  LatLng _getClosestPointOnSegment(LatLng start, LatLng end, LatLng point) {
    final px = point.latitude;
    final py = point.longitude;

    final ax = start.latitude;
    final ay = start.longitude;
    final bx = end.latitude;
    final by = end.longitude;

    final abx = bx - ax;
    final aby = by - ay;
    final apx = px - ax;
    final apy = py - ay;

    final abSquared = abx * abx + aby * aby;
    final apDotAb = apx * abx + apy * aby;
    final t = max(0, min(1, apDotAb / abSquared));

    return LatLng(ax + t * abx, ay + t * aby);
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const earthRadius = 6371000.0; // in meters

    final lat1 = p1.latitude * pi / 180.0;
    final lat2 = p2.latitude * pi / 180.0;
    final deltaLat = (p2.latitude - p1.latitude) * pi / 180.0;
    final deltaLng = (p2.longitude - p1.longitude) * pi / 180.0;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Snap Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _polylinePoints.first,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            polylines: _polylines,
            onTap: (LatLng position) {
              setState(() {
                _closestPoint = _findClosestPoint(position);
              });
            },
            markers: _closestPoint != null ? _marker : {},
          ),
          if (_closestPoint != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                'Snapped to: ${_closestPoint!.latitude}, ${_closestPoint!.longitude}',
                style: TextStyle(fontSize: 16, backgroundColor: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class AudioRecordExample extends StatefulWidget {
  @override
  _AudioRecordExampleState createState() => _AudioRecordExampleState();
}

class _AudioRecordExampleState extends State<AudioRecordExample> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _player.openPlayer();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    _audioPath = "audio_${DateTime.now().millisecondsSinceEpoch}.aac";
    await _recorder.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
  }

  Future<void> _playAudio() async {
    if (_audioPath?.isEmpty ?? true) return;
    try {
      await _player.startPlayer(
        fromURI: _audioPath,
        codec: Codec.aacADTS,
      );
      setState(() => _isPlaying = true);
      /*  _player.startPlayerCompleted.listen((_) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });*/
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _stopAudio() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Record Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            ElevatedButton(
              onPressed: _isPlaying ? _stopAudio : _playAudio,
              child: Text(_isPlaying ? "Stop Audio" : "Play Audio"),
            ),
          ],
        ),
      ),
    );
  }
}
