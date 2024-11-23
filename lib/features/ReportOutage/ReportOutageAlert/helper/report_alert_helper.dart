import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';
import '../presentation/widget/alert_dialog_widget.dart';

class ReportAlertHelper {
  static Future<void> clearCache() async {
    Directory path = Directory("/data/user/0/unistal.igloutage.app/cache/");

    if (await path.exists()) {
      List<FileSystemEntity> files = path.listSync();
      for (FileSystemEntity f in files) {
        if (f is File) {
          await f.delete();
        }
      }
    }

    Directory path2 =
        Directory("/data/user/0/unistal.igloutage.app/cache/file_picker/");

    if (await path2.exists()) {
      path2.deleteSync(recursive: true);
    }

    Directory path3 =
        Directory("/data/user/0/unistal.igloutage.app/cache/diskcache/");

    if (await path3.exists()) {
      path3.deleteSync(recursive: true);
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

  static Future<GetTfGisModel?> getTFGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getTFGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getGasValueGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getRegulatorGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getTeeGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getElbowGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getCouplerGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getReducerGisApi(
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getEndCapGisApi(
      {required BuildContext context}) async {
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
        GetTfGisModel response = GetTfGisModel.fromJson(res);
        if (response.data!.isNotEmpty) {
          if (await HiveDataBase.allGisDataBox!.isOpen) {
            await HiveDataBase.allGisDataBox!.clear();
            HiveDataBase.allGisDataBox!.addAll(response.data!);
          }
        }
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
      GetPipelineNetworkModel response = GetPipelineNetworkModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineNetwork-->${e.toString()}");
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
          width: 8,
          points: latlngList,
          color: color,
          jointType: JointType.bevel,
          onTap: () async {},
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
}
