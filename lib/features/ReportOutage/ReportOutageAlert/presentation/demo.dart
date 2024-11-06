// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class Demo extends StatefulWidget {
//   const Demo({super.key});
//
//   @override
//   State<Demo> createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   Completer<GoogleMapController> _controllerGoogleMap = Completer();
//   late GoogleMapController newGoogleMapController;
//   late Position currentPosition;
//   var geoLocator = Geolocator();
//   Map<MarkerId, Marker> markers = {};
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//
//
//   void locatePosition() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     currentPosition = position;
//   }
//
//   static final CameraPosition _UserLocation = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     //target: LatLng(26.0667, 50.5577),
//     zoom: 16,
//   );
//   @override
//   void initState() {
//     super.initState();
//     locatePosition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         myLocationButtonEnabled: true,
//         initialCameraPosition: _UserLocation,
//         polylines: Set<Polyline>.of(polylines.values),
//         markers: Set<Marker>.of(markers.values),
//         myLocationEnabled: true,
//         zoomGesturesEnabled: true,
//         zoomControlsEnabled: true,
//         onMapCreated: (GoogleMapController controller) {
//           _controllerGoogleMap.complete(controller);
//           newGoogleMapController = controller;
//           _getPolyline();
//
//           setState(() {});
//         },
//       ),
//     );
//   }
//
//   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker =
//     Marker(markerId: markerId, icon: descriptor, position: position);
//     markers[markerId] = marker;
//   }
//
//   _addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }
//
//   void _getPolyline() async {
//     /// add origin marker origin marker
//     _addMarker(
//       LatLng(currentPosition.latitude, currentPosition.longitude),
//       "origin",
//       BitmapDescriptor.defaultMarker,
//     );
//
//     // Add destination marker
//     _addMarker(
//       LatLng(dest_location.latitude, dest_location.longitude),
//       "destination",
//       BitmapDescriptor.defaultMarkerWithHue(90),
//     );
//
//     List<LatLng> polylineCoordinates = [];
//
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "Your_key",
//       PointLatLng(currentPosition.latitude, currentPosition.longitude),
//       PointLatLng(dest_location.latitude, dest_location.longitude),
//       travelMode: TravelMode.walking,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     _addPolyLine(polylineCoordinates);
//   }
// }
// const LatLng dest_location = LatLng(37.42796133580664, -122.085749655962);