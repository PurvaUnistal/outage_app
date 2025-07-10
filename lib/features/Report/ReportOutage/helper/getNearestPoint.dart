import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearestPolylinePoint{
 static bool isPointNearLine(LatLng point, LatLng start, LatLng end, ) {
    double distance = distanceFromPointToLine(point, start, end);
    return distance < 40;
  }

 static  double distanceFromPointToLine(LatLng point, LatLng start, LatLng end) {
    // Calculate the distance from `point` to the line segment `start`-`end`.
    final double A = point.latitude - start.latitude;
    final double B = point.longitude - start.longitude;
    final double C = end.latitude - start.latitude;
    final double D = end.longitude - start.longitude;

    final double dot = A * C + B * D;
    final double len_sq = C * C + D * D;
    final double param = len_sq != 0 ? dot / len_sq : -1;

    double xx, yy;

    if (param < 0) {
      xx = start.latitude;
      yy = start.longitude;
    } else if (param > 1) {
      xx = end.latitude;
      yy = end.longitude;
    } else {
      xx = start.latitude + param * C;
      yy = start.longitude + param * D;
    }

    final double dx = point.latitude - xx;
    final double dy = point.longitude - yy;
    return sqrt(dx * dx + dy * dy) * 111320;
  }





}