import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/res/secrets.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/getNearestPoint.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapService {
  final GoogleMapController? mapController;

  MapService({this.mapController});


  /// Get current location with permission checks
  Future<LatLng?> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      debugPrint('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permission permanently denied.');
      return null;
    }

    final position = await CurrentLocation.getCurrentLocation();
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  static getAddress({required LatLng latLng}) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      Placemark place = p[0];
      String currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
       return currentAddress;

    } catch (e) {
      print(e);
    }
  }

  /// Calculate distance and setup markers, camera & polyline
  Future<double?> calculateAndDisplayRoute({
    required String startAddress,
    required String destinationAddress,
    required LatLng currentPosition,
    required TextEditingController startAddressController,
    required Set<Marker> markers,
    required List<LatLng> polylineCoordinates,
    required Set<Polyline> polylines,
  required GoogleMapController controller,
  }) async {
    try {
      // 🔷 Step 1: Resolve start & destination positions
      final currentAddress = await getAddress(latLng: currentPosition);
      final startLocations = await locationFromAddress(startAddress);
      final destLocations = await locationFromAddress(destinationAddress);

      late double startLat, startLng;

      if (startAddress == currentAddress) {
        startLat = currentPosition.latitude;
        startLng = currentPosition.longitude;
      } else {
        startLat = startLocations.first.latitude;
        startLng = startLocations.first.longitude;
      }

      final destLat = destLocations.first.latitude;
      final destLng = destLocations.first.longitude;

      final startLatLng = LatLng(startLat, startLng);
      final destLatLng = LatLng(destLat, destLng);

      // 🔷 Step 2: Update markers
      markers
        ..clear()
        ..addAll([
          Marker(
            markerId: const MarkerId('start'),
            position: startLatLng,
            infoWindow: InfoWindow(title: 'Start', snippet: startAddress),
            icon: BitmapDescriptor.defaultMarker,
          ),
          Marker(
            markerId: const MarkerId('dest'),
            position: destLatLng,
            infoWindow:
            InfoWindow(title: 'Destination', snippet: destinationAddress),
            icon: BitmapDescriptor.defaultMarker,
          ),
        ]);

      debugPrint('START COORDINATES: ($startLat, $startLng)');
      debugPrint('DESTINATION COORDINATES: ($destLat, $destLng)');

      // 🔷 Step 3: Animate camera to fit both points
      final bounds = _boundsFromLatLngs([startLatLng, destLatLng]);
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

      // 🔷 Step 4: Draw polyline
      await createPolylines(
        startLat:startLat ,
          startLng: startLng,destLat: destLat,destLng:  destLng,
      polylineCoordinates: polylineCoordinates,
      polylines: polylines);

      // 🔷 Step 5: Calculate total distance of the route
      double totalDistance = 0.0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      debugPrint('TOTAL DISTANCE: ${totalDistance.toStringAsFixed(2)} km');
      return totalDistance;

    } catch (e, stackTrace) {
      debugPrint('❌ Error calculating route: $e');
      debugPrint(stackTrace.toString());
      return null;
    }
  }



  /// Create polylines
  Future<void> createPolylines({
    required double startLat,
    required double startLng,
    required double destLat,
    required double destLng,
    required List<LatLng> polylineCoordinates,
    required Set<Polyline> polylines,
  }) async {
    polylineCoordinates.clear();
    polylines.clear();

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Secrets.API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(startLat, startLng),
        destination: PointLatLng(destLat, destLng),
        mode: TravelMode.transit,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.addAll(
        result.points.map((p) => LatLng(p.latitude, p.longitude)),
      );
    } else {
      debugPrint("❌ No polyline points found: ${result.errorMessage}");
    }

    Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.red,
      width: 4,
      points: polylineCoordinates,
    );

    polylines.add(polyline);
  }


  /// Compute distance between two points (Haversine)
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295; // π/180
    const c = cos;
    final a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // km
  }

  /// Compute bounds
  LatLngBounds _boundsFromLatLngs(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }


  /// Build Google Maps directions URL
  String buildGoogleMapsUrl(LatLng origin, LatLng destination) {
    return "https://www.google.com/maps/dir/?api=1"
        "&origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&travelmode=driving&dir_action=navigate";
  }

  /// Check if a point is near any of the given polylines
  bool isPointNearAnyPolyline(LatLng point, Set<Polyline> polylinePointList) {
    for (var polyData in polylinePointList) {
      for (int i = 0; i < polyData.points.length - 1; i++) {
        final start = polyData.points[i];
        final end = polyData.points[i + 1];
        if (NearestPolylinePoint.isPointNearLine(point, start, end)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      print("Launching URI --> $uri");
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
