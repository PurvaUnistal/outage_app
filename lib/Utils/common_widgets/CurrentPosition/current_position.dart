import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocation{
 static Future<Position?> getCurrentLocation() async {
   await Geolocator.requestPermission();
   await Permission.locationAlways.request();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if(position != ''){
      return position;
    }
    return position;
  }
  }


