import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigateAlertHelper{
  static dynamic createMarker({
    required List<LatLng> latlngList,
    required BuildContext context,
    required BitmapDescriptor markerIcon,
  }) async {
    Set<Marker> markersPointList = {};
    try {
      for (var latLngData in latlngList) {
        markersPointList.add(Marker(
          markerId: MarkerId("${latLngData.latitude.toString()}"),
          infoWindow: InfoWindow(
            title: "${latLngData.latitude.toString()}, "
                "${latLngData.longitude.toString()}",
          ),
          position: LatLng(latLngData.latitude, latLngData.longitude),
          icon: markerIcon,
        ));
      }
    } catch (_) {};
    return markersPointList;
  }
}