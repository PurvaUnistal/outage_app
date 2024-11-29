import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocation {
  static Future<Position?> getCurrentLocation() async {
    await Geolocator.requestPermission();
    await Permission.locationAlways.request();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != '') {
      return position;
    }
    return position;
  }

  static Future<String?> getAddress() async {
    try {
      Position? currentPoint = await CurrentLocation.getCurrentLocation();
      if(currentPoint != null){
        List<Placemark> p = await placemarkFromCoordinates(currentPoint.latitude, currentPoint.longitude);
        Placemark place = p[0];
        String  currentAddress = "${place.name}, ${place.locality},${place.subLocality}, ${place.postalCode}, ${place.country}";
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
