import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/filter_key_enum.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/alert_dialog_widget.dart';

class ReportMarkerPolyline {
  static Future<BitmapDescriptor> markerAsset({required String path}) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(28, 28)),
      path,
    );
  }

  static Future<Uint8List> generateDotImage({
    required Color color,
    double size = 20.0,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    final img = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

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
          AppConfig.instanceInit()?.setData(newData: data);
          AppConfig.instanceInit()?.setFilterByKey(filterByKey: filterByKey!);
          AppConfig.instanceInit()?.setMarkerPoint(
            newPointMarkerLat: position.latitude.toString(),
            newPointMarkerLong: position.longitude.toString(),
          );
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: AlertDialogTwoBtnWidget(
                    pipelineData: data,
                    filterByKey:
                        filterByKey == FilterKey.BP_NUMBER
                            ? "BP : ${data.bpNumber}"
                            : filterByKey == FilterKey.VALUE_ID
                            ? 'Valve : ${data.valveId}'
                            : filterByKey == FilterKey.RegulatorId
                            ? 'Regulator : ${data.regulatorid}'
                            : filterByKey == FilterKey.SERVICE_ID
                            ? "Service ID : ${data.servicePointId}"
                            : 'ID: ${data.id}',
                  ),
                ),
          );
        },
        markerId: MarkerId(data.id.toString()),
        position: position,
        infoWindow: InfoWindow(
          title:
              filterByKey == FilterKey.BP_NUMBER
                  ? "BP"": ${data.bpNumber}"
                  : filterByKey == FilterKey.VALUE_ID
                  ? 'Valve : ${data.valveId}'
                  : filterByKey == FilterKey.RegulatorId
                  ? 'Regulator : ${data.regulatorid}'
                  : filterByKey == FilterKey.SERVICE_ID
                  ? "Service ID : ${data.servicePointId}"
                  : 'ID: ${data.id}',
        ),
        icon: icon,
      ),
    );
    return markersPointList;
  }

  static Set<Polyline> polylinePoint({
    required int i,
    required Color color,
    required List<LatLng> position,
    required BuildContext context,
  }) {
    Set<Polyline> polylineList = {};
    polylineList.add(
      Polyline(
        polylineId: PolylineId("polyline_$i"),
        points: position,
        color: color,
        zIndex: 10,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 4,
        onTap: () {
          print("-------------------------------->polyline_$i");
          AppConfig.instanceInit()?.setData(newData: "");
        },
      ),
    );
    return polylineList;
  }
  static Color getPolylineColor({
    required int value,
    required Map<String, String> colorMap,
  }) {
    for (var entry in colorMap.entries) {
      // Split the key range, e.g. "0-20"
      final parts = entry.key.split('-');
      if (parts.length == 2) {
        final start = int.tryParse(parts[0]) ?? 0;
        final end = int.tryParse(parts[1]) ?? 0;

        if (value >= start && value <= end) {
          return Color(int.parse(entry.value));
        }
      }
    }

    // Default color if no range matches
    return Colors.blue.shade800;
  }


  // static Color getPolylineColor({
  //   required int value,
  //   required List<String> color,
  // }) {
  //   if (color.length < 4) {
  //     throw ArgumentError('color list must have at least 4 values');
  //   }
  //
  //   if (value >= 0 && value <= 50) {
  //     return Color(int.parse(color[0]));
  //   } else if (value >= 63 && value <= 90) {
  //     return Color(int.parse(color[1]));
  //   } else if (value >= 100 && value <= 140) {
  //     return Color(int.parse(color[2]));
  //   } else if (value >= 150 && value <= 200) {
  //     return Color(int.parse(color[3]));
  //   } else {
  //     return Colors.blue.shade800; // default color
  //   }
  // }

  static showMyCupertinoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Alert'),
          content: Text('This is a Cupertino-style dialog.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('OK'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                // Add your logic here
              },
            ),
          ],
        );
      },
    );
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
          final markers = ReportMarkerPolyline.markerPoint(
            icon: bitmapDescriptor,
            position: latLng,
            context: context,
            data: data,
            filterByKey: filterByKey,
          );

          targetMarkerSet.addAll(markers);
          finalMarker.addAll(markers);
        } catch (e) {
          print("Error parsing coordinates: $e");
        }
      }
    }
  }
}
