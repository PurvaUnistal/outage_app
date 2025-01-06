import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';
import 'package:path_provider/path_provider.dart';
import '../presentation/widget/alert_dialog_widget.dart';

class ReportAlertHelper {
  static Future<void> clearCache() async {
   /* Directory path = Directory("/data/user/0/unistal.igloutage.app/cache/");

    if (await path.exists()) {
      List<FileSystemEntity> files = path.listSync();
      for (FileSystemEntity f in files) {
        if (f is File) {
          await f.delete();
        }
      }
    }*/

    Directory path2 =
        Directory("/data/user/0/unistal.igloutage.app/file_picker/");
    if (await path2.exists()) {
      path2.deleteSync(recursive: true);
    }

    Directory path3 =
        Directory("/data/user/0/unistal.igloutage.app/cache/diskcache/");

    if (await path3.exists()) {
      path3.deleteSync(recursive: true);
    }
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<GetPipelineGisModel?> getPipelineGisApi(
      {required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPipelineGis, context: context);
      GetPipelineGisModel response = GetPipelineGisModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasValueGISModel?> getFittingGisApi(
      {required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getFittingGis, context: context);
      if (res != null) {
        GetGasValueGISModel response = GetGasValueGISModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getTFGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getTFGis + json, context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getTFGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getGasValueGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getGasValueGis + json, context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getRegulatorGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getRegulatorGis + json, context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getTeeGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "type": "Tee",
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getNonControllableFittingGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getElbowGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "type": "Elbow",
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getNonControllableFittingGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getCouplerGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "type": "Coupler",
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getNonControllableFittingGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getReducerGisApi(
      {required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "type": "Reducer",
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getNonControllableFittingGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getEndCapGisApi({required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    try {
      Map<String, String> para = {
        "type": "End Cap",
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getNonControllableFittingGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getConsumerGisApi({required BuildContext context}) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    String schema = await SharedPref.getString(key: PrefsValue.schema);
    try {
      Map<String, String> para = {
        "schema": schema,
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getConsumerGis + json,
          context: context);
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPipelineNetworkModel?> getPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    Map<String, String> para = {
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      log(Apis.getPipelineNetwork + json);
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPipelineNetwork + json, context: context);
      if (res != null) {
        GetPipelineNetworkModel response =
            GetPipelineNetworkModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getPipelineNetwork-->${e.toString()}");
    }
    return null;
  }

  static Future<PipelineModel?> getPipelineApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    String gaId = await SharedPref.getString(key: PrefsValue.gaId);
    String areas = await SharedPref.getString(key: PrefsValue.areas);
    Map<String, String> para = {
      "ga_id": gaId,
      "areas": areas,
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      log("Apis.getPipeline-->${Apis.getPipeline + json}");
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPipeline + json, context: context);
      if (res != null) {
        PipelineModel response =
        PipelineModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getPipeline-->${e.toString()}");
    }
    return null;
  }

  static dynamic createMarker({
    required List<LatLng> latlngList,
    required BuildContext context,
    required BitmapDescriptor markerIcon,
  }) async {
    Set<Marker> markersPointList = {};
    try {
      for (var latLngData in latlngList) {
        markersPointList.clear();
        markersPointList.add(Marker(
          icon: markerIcon,
          markerId: MarkerId("${latLngData.latitude},${latLngData.longitude}"),
          infoWindow: InfoWindow(
            title: "${latLngData.latitude.toString()}, "
                "${latLngData.longitude.toString()}",
          ),
          position: LatLng(latLngData.latitude, latLngData.longitude),
          onTap: () async {
            await SharedPref.setString(
                key: PrefsValue.markerLat,
                value: latLngData.latitude.toString());
            await SharedPref.setString(
                key: PrefsValue.markerLong,
                value: latLngData.longitude.toString());
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (BuildContext c) {
                  return AlertDialogTwoBtnWidget();
                });
          },
        ));
      }
    } catch (_) {};
    return markersPointList;
  }

  static Future<dynamic> createPolyLine(
      {required List<LatLng> latlngList,
      required Color color,
      required BuildContext context}) async {
    Set<Polyline> polylineList = {};
    try {
      if (latlngList.isNotEmpty) {
        polylineList.clear();
        polylineList.add(Polyline(
          polylineId: PolylineId(latlngList.toString()),
          visible: true,
          width: 6,
          points: latlngList,
          color: color,
          jointType: JointType.bevel,
          onTap: () async {},
           /* endCap: Cap.squareCap,
            geodesic: false,
            patterns: [PatternItem.dot, PatternItem.gap(10)]*/
        ));
      }
    } catch (_) {}
    return polylineList;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Color getPolylineColor(int value) {
    if (value < 0 || value > 50) {
      return Colors.green;
    } else if (value < 63 || value > 90) {
      return Colors.red;
    } else if (value < 100 || value > 140) {
      return Colors.purple;
    } else if (value < 150 || value > 200) {
      return Colors.teal;
    } else {
      return Colors.blue.shade800;
    }
  }

}
