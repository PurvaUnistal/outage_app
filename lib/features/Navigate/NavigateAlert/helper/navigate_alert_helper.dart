import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/filter_key_enum.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/widget/alert_dialog_details_widget.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/report_marker_polyline.dart';

class NavigateAlertHelper {
  static Set<Marker> markerPoint({
    required BitmapDescriptor icon,
    required LatLng position,
    required BuildContext context,
    required dynamic data,
    FilterKey? filterByKey,
    String? searchText,
  }) {
    Set<Marker> markersPointList = {};
    markersPointList.add(
      Marker(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: AlertDialogDetailsWidgetWidget(
                    mContext: context,
                    pipelineData: data,
                  ),
                ),
          );
        },
        markerId: MarkerId('${position.latitude.toString()}'),
        position: position,
        infoWindow: InfoWindow(title:
        filterByKey == FilterKey.BP_NUMBER
            ? "BP"
            ": ${data.bpNumber}"
            : filterByKey == FilterKey.VALUE_ID
            ? 'Valve : ${data.valveId}'
            : 'ID: ${data.id}',),
        icon: icon,
      ),
    );
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

  static Future<void> processMarkersInBatches({
    required BuildContext context,
    required List<dynamic> dataList,
    required Set<Marker> targetMarkerSet,
    required Set<Marker> finalMarker,
    required FilterKey filterByKey,
    Color? dotColor,
    String? assetPath,

  }) async {
    late BitmapDescriptor bitmapDescriptor;
    if (assetPath != null) {
      bitmapDescriptor = await ReportMarkerPolyline.markerAsset(
        path: assetPath,
      );
    } else if (dotColor != null) {
      final dotIconBytes = await ReportMarkerPolyline.generateDotImage(
        color: dotColor,
      );
      bitmapDescriptor = BitmapDescriptor.bytes(dotIconBytes);
    } else {
      throw ArgumentError("Either dotColor or assetPath must be provided");
    }

    const int batchSize = 500;
    for (int i = 0; i < dataList.length; i += batchSize) {
      final batch = dataList.skip(i).take(batchSize).toList();
      print("🔄 Batch ${i ~/ batchSize + 1}: ${batch.length} items");

      for (var data in batch) {
        try {
          final lat = double.tryParse(data.latitude ?? '');
          final lng = double.tryParse(data.longitude ?? '');
          if (lat == null || lng == null) continue;

          final latLng = LatLng(lat, lng);
          final markers = NavigateAlertHelper.markerPoint(
            icon: bitmapDescriptor,
            position: latLng,
            context: context,
            data: data,
            filterByKey: filterByKey,
          );

          targetMarkerSet.addAll(markers);
          finalMarker.addAll(markers); // Keep if you're combining everything
        } catch (e) {
          print("Error parsing coordinates: $e");
        }
      }
    }
  }
}
