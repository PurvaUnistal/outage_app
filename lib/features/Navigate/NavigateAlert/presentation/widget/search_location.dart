// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   LocationData? _currentLocation;
//   Location _locationService = Location();
//
//   // Markers
//   final Set<Marker> _markers = {};
//
//   // Polylines
//   final Set<Polyline> _polylines = {};
//   List<LatLng> _polylineCoordinates = [];
//   final PolylinePoints _polylinePoints = PolylinePoints();
//
//   // Pickup location
//   LatLng _pickupLocation = LatLng(28.614414, 77.377138);
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     // Check if location services are enabled
//     serviceEnabled = await _locationService.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _locationService.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     // Check for location permissions
//     permissionGranted = await _locationService.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _locationService.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//
//     // Get the current location
//     _currentLocation = await _locationService.getLocation();
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId("current_location"),
//           position: LatLng(
//             _currentLocation!.latitude!,
//             _currentLocation!.longitude!,
//           ),
//           infoWindow: InfoWindow(title: "Current Location"),
//         ),
//       );
//       _markers.add(
//         Marker(
//           markerId: MarkerId("pickup_location"),
//           position: _pickupLocation,
//           infoWindow: InfoWindow(title: "Pickup Location"),
//         ),
//       );
//     });
//
//     _drawPolyline();
//   }
//
//   Future<void> _drawPolyline() async {
//     if (_currentLocation == null) return;
//
//     PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey:"AIzaSyAGSC08nb7Cq2mSVqaZWNVX4cIPdUSONps",
//         request: PolylineRequest(
//           origin: PointLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
//           destination:  PointLatLng(_pickupLocation.latitude, _pickupLocation.longitude),
//           mode: TravelMode.driving,
//           wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
//         )
//     );
//
//     if (result.status == "OK") {
//       result.points.forEach((point) {
//         _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//       setState(() {
//         _polylines.add(
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: _polylineCoordinates,
//             color: Colors.blue,
//             width: 5,
//           ),
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Map Example")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             _currentLocation!.latitude!,
//             _currentLocation!.longitude!,
//           ), // Default coordinates
//           zoom: 14.0,
//         ),
//         markers: _markers,
//         polylines: _polylines,
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//           if (_currentLocation != null) {
//             _mapController!.animateCamera(
//               CameraUpdate.newLatLngZoom(
//                 LatLng(
//                   _currentLocation!.latitude!,
//                   _currentLocation!.longitude!,
//                 ),
//                 14.0,
//               ),
//             );
//           }
//         },
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Location _location = Location();
  LatLng? _currentLocation;
  LatLng? _pickupLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    LocationData locationData = await _location.getLocation();

    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: "Your Location"),
        ),
      );
    });

    _location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        _currentLocation =
            LatLng(newLocation.latitude!, newLocation.longitude!);
      });
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _pickupLocation = position;
      _markers.add(
        Marker(
          markerId: MarkerId("pickup_location"),
          position: position,
          infoWindow: InfoWindow(title: "Pickup Location"),
        ),
      );
    });
    if (_currentLocation != null && _pickupLocation != null) {
      _drawRoute(_currentLocation!, _pickupLocation!);
    }
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyAGSC08nb7Cq2mSVqaZWNVX4cIPdUSONps",
      request: PolylineRequest(
          origin: PointLatLng(start.latitude, start.longitude),
          destination: PointLatLng(end.latitude, end.longitude),
          mode: TravelMode.walking),
    );
    if (result.status == "OK") {
      _polylineCoordinates.clear();
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route Finder")),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        buildingsEnabled: false,
        rotateGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 14.0,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: _onMapTap,
      ),
    );
  }
}
