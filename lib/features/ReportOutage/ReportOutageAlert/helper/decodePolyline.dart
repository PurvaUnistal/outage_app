import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PointLatLngModel.dart';
import 'dart:math' as math;

class DecodePolyline{
  static List<LatLng> decodePolyline(String polyline,

      {int accuracyExponent = 5}) {

    final accuracyMultiplier = math.pow(10, accuracyExponent);

    List<LatLng> coordinates = [];

    int index = 0;

    int lat = 0;

    int lng = 0;

    while (index < polyline.length) {

      int char;

      int shift = 0;

      int result = 0;



      int getCoordinate() {

        do {

          char = polyline.codeUnitAt(index++) - 63;

          result |= (char & 0x1f) << shift;

          shift += 5;

        } while (char >= 0x20);

        final value = result >> 1;

        final coordinateChange =

        (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;



        shift = result = 0;

        return coordinateChange;

      }

      lat += getCoordinate();

      lng += getCoordinate();

      coordinates.add(

          LatLng( lat / accuracyMultiplier, lng / accuracyMultiplier));

    }

    return coordinates;

  }
}