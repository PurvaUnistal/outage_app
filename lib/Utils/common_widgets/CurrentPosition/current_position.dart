import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocation {
  /*static Future<Position?> getCurrentLocation() async {
    await Geolocator.requestPermission();
    await Permission.locationAlways.request();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != '') {
      return position;
    }
    return position;
  }*/
  static Future<Position?> getCurrentLocation() async {
    // Check if location services are enabled
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission permanently denied.');
    }

    // Define location settings
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    // Create a stream of position updates
    Stream<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings);

    // Wait for the first position update
    Position? currentPosition = await positionStream.first;

    return currentPosition;
  }

  static Future<String?> getAddress() async {
    try {
      Position? currentPoint = await CurrentLocation.getCurrentLocation();
      if (currentPoint != null) {
        List<Placemark> p = await placemarkFromCoordinates(
            currentPoint.latitude, currentPoint.longitude);
        Placemark place = p[0];
        String currentAddress =
            "${place.name}, ${place.locality},${place.subLocality}, ${place.postalCode}, ${place.country}";
        return currentAddress;
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  static moveMapToCenter({required Location location}) {
    LatLng latLng = new LatLng(location.latitude, location.longitude);
    if (latLng != null) {}
  }
}
