import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearestPolylinePoint{
 static bool isPointNearLine(LatLng point, LatLng start, LatLng end, double threshold) {
    double distance = distanceFromPointToLine(point, start, end);
    return distance < threshold;
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

  /////////////////////////////////////////////////////////////////////////////////////////////////////




 static LatLng getClosestPointOnSegment(LatLng start, LatLng end, LatLng point) {
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

 static double calculateDistance(LatLng p1, LatLng p2) {
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
}