import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/widget/alert_dialog_details_widget.dart';

class NavigateAlertHelper{


static Set<Marker> markerPoint({
  required BitmapDescriptor icon,
  required LatLng position,
  required String assetsTypeId,
  required BuildContext context,
  required dynamic data,
}) {
  Set<Marker> markersPointList = {};
  markersPointList.add(Marker(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: AlertDialogDetailsWidgetWidget(mContext: context,pipelineData: data,),
        ),
      );
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
  InfoWindow? infoWindow,
  Function()? onTap,
}) {
  Set<Marker> markersPointList = {};
  for (LatLng latLng in position) {
    markersPointList.add(
      Marker(
        markerId: MarkerId('${latLng.latitude}_${latLng.longitude}'),
        position: latLng,
        icon: icon,
        onTap: onTap,
        infoWindow: infoWindow ?? const InfoWindow(title: '', snippet: ''),
      ),
    );
  }
  return markersPointList;
}


}