import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';
import 'package:path_provider/path_provider.dart';
import '../presentation/widget/alert_dialog_widget.dart';

class ReportAlertHelper {
  static Future<void> clearCache() async {
    try {
      Directory pathIGL1 = Directory(
          "/data/user/0/${AppConfig.instanceInit()?.packageName}/file_picker/");
      Directory pathIGL2 = Directory(
          "/data/user/0/${AppConfig.instanceInit()?.packageName}/cache/diskcache/");

      if (await pathIGL1.exists()) {
        await pathIGL1.delete(recursive: true);
      }
      if (await pathIGL2.exists()) {
        await pathIGL2.delete(recursive: true);
      }

      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
      log("Cache cleared successfully.");
    } catch (e) {
      log("Error clearing cache: $e");
    }
  }

  static Future<GetPipelineGisModel?> getPipelineGisApi(
      {required BuildContext context}) async {
    try {
      String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
      String areas =
          await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
      Map<String, String> para = {
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPipelineGis + json, context: context);
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
      String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
      String areas =
          await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
      Map<String, String> para = {
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getFittingGis + json, context: context);
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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

  static Future<GetGasGisModel?> getEndCapGisApi(
      {required BuildContext context}) async {
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
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

  static Future<GetGasGisModel?> getConsumerGisApi(
      {required BuildContext context}) async {
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    String schema =
        await AppConfig.instanceInit()?.loginData.user?.schema ?? "";
    try {
      Map<String, String> para = {
        "schema": schema,
        "ga_id": gaId,
        "areas": areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getConsumerGis + json, context: context);
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    Map<String, String> para = {
      "ga_id": gaId,
      "areas": areas,
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
    String gaId = await AppConfig.instanceInit()?.loginData.user?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    Map<String, String> para = {
      "ga_id": gaId,
      "areas": areas,
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getPipeline + json, context: context);
      if (res != null) {
        PipelineModel response = PipelineModel.fromJson(res);
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
            AppConfig.instanceInit()?.setMarkerPoint(
                newPointMarkerLat: latLngData.latitude.toString(),
                newPointMarkerLong: latLngData.longitude.toString());
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (BuildContext c) {
                  return AlertDialogTwoBtnWidget(mContext: context);
                });
          },
        ));
      }
    } catch (_) {}
    ;
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
          width: 3,
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
      return Colors.pinkAccent;
    } else if (value < 100 || value > 140) {
      return Colors.purple;
    } else if (value < 150 || value > 200) {
      return Colors.teal;
    } else {
      return Colors.blue.shade800;
    }
  }
}
