import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigateAlertHelper{


static Set<Marker> markerPoint({
  required BitmapDescriptor icon,
  required LatLng position,
  required String assetsTypeId,
  required BuildContext context,
}) {
  Set<Marker> markersPointList = {};
  markersPointList.add(Marker(
    onTap: () {
    },
    markerId: MarkerId('${position.latitude.toString()}'),
    position: position,
    infoWindow: InfoWindow(title: assetsTypeId,),
    icon: icon,
  ));
  return markersPointList;
}

static Set<Marker> markerIncident({
  required BitmapDescriptor icon,
  required List<LatLng> position,
  required BuildContext context,
}) {
  Set<Marker> markersPointList = {};
  for (LatLng latLng in position) {
    markersPointList.add(
      Marker(
        markerId: MarkerId('${latLng.latitude}_${latLng.longitude}'),
        position: latLng,
        icon: icon,
      ),
    );
  }
  return markersPointList;
}


}