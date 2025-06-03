import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/IndustrialModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ValveGISModel.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';
import 'package:path_provider/path_provider.dart';
import '../presentation/widget/alert_dialog_widget.dart';

class ReportAlertHelper {
  static Future<void> clearCache() async {
    try {
      Directory pathIGL1 = Directory(
        "/data/user/0/${AppConfig.instanceInit()?.packageName}/file_picker/",
      );
      Directory pathIGL2 = Directory(
        "/data/user/0/${AppConfig.instanceInit()?.packageName}/cache/diskcache/",
      );

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

  static Future<PipelineModel?> getPipelineGisApi({
    required BuildContext context,
  }) async {
    try {
      String gaId = await AppConfig.instanceInit()?.gaId ?? "";
      String areas =
          await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
      Map<String, String> para = {"ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getPipelineGis + json,
        context: context,
      );
      PipelineModel response = PipelineModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasValueGISModel?> getFittingGisApi({
    required BuildContext context,
  }) async {
    try {
      String gaId = await AppConfig.instanceInit()?.gaId ?? "";
      String areas =
          await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
      Map<String, String> para = {"ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getFittingGis + json,
        context: context,
      );
      if (res != null) {
        GetGasValueGISModel response = GetGasValueGISModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<TFGISModel?> getTFGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    try {
      Map<String, String> para = {"ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getTFGis + json,
        context: context,
      );
      if (res != null) {
        TFGISModel response = TFGISModel.fromJson(res);
        if (await HiveDataBase.tfGISBox!.isOpen) {
          await HiveDataBase.tfGISBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.tfGISBox!.add(data);
          }
        }
        return response;
      }
    } catch (e) {
      log("getTFGis-->${e.toString()}");
    }
    return null;
  }

  static Future<ValveGISModel?> getGasValueGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    try {
      Map<String, String> para = {"ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getGasValueGis + json,
        context: context,
      );
      if (res != null) {
        ValveGISModel response = ValveGISModel.fromJson(res);
        if (await HiveDataBase.valveGISBox!.isOpen) {
          await HiveDataBase.valveGISBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.valveGISBox!.add(data);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<RegulatorGISModel?> getRegulatorGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    try {
      Map<String, String> para = {"ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getRegulatorGis + json,
        context: context,
      );
      if (res != null) {
        RegulatorGISModel response = RegulatorGISModel.fromJson(res);
        if (await HiveDataBase.regulatorGISBox!.isOpen) {
          await HiveDataBase.regulatorGISBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.regulatorGISBox!.add(data);
          }
        }
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<CommercialModel?> getCommercialApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    String? schema =
        AppConfig.instanceInit()?.loginData.user!.isHo == "1"
            ? AppConfig.instanceInit()?.hoSchema
            : AppConfig.instanceInit()?.loginData.user!.schema;
    try {
      Map<String, String> para = {
        "schema": schema ?? "",
        "ga_id": gaId,
        "areas": areas,
        "type": "1",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getConsumerGis + json,
        context: context,
      );
      if (res != null) {
        CommercialModel response = CommercialModel.fromJson(res);
        if (await HiveDataBase.commercialDataBox!.isOpen) {
          await HiveDataBase.commercialDataBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.commercialDataBox!.add(data);
          }
        }
      }
    } catch (e) {
      log("CommercialModel-->${e.toString()}");
    }
    return null;
  }

  static Future<DomesticModel?> getDomesticApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    String? schema =
    AppConfig.instanceInit()?.loginData.user!.isHo == "1"
        ? AppConfig.instanceInit()?.hoSchema
        : AppConfig.instanceInit()?.loginData.user!.schema;
    try {
      Map<String, String> para = {
        "schema": schema ?? "",
        "ga_id": gaId,
        "areas": areas,
        "type": "2",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getConsumerGis + json,
        context: context,
      );
      if (res != null) {
        DomesticModel response = DomesticModel.fromJson(res);
        if (await HiveDataBase.domesticDataBox!.isOpen) {
          await HiveDataBase.domesticDataBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.domesticDataBox!.add(data);
          }
        }
      }
    } catch (e) {
      log("DomesticModel-->${e.toString()}");
    }
    return null;
  }

  static Future<IndustrialModel?> getIndustrialApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    String? schema =
    AppConfig.instanceInit()?.loginData.user!.isHo == "1"
        ? AppConfig.instanceInit()?.hoSchema
        : AppConfig.instanceInit()?.loginData.user!.schema;
    try {
      Map<String, String> para = {
        "schema": schema ?? "",
        "ga_id": gaId,
        "areas": areas,
        "type": "3",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getConsumerGis + json,
        context: context,
      );
      if (res != null) {
        IndustrialModel response = IndustrialModel.fromJson(res);
        if (await HiveDataBase.industrialDataBox!.isOpen) {
          await HiveDataBase.industrialDataBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.industrialDataBox!.add(data);
          }
        }
      }
    } catch (e) {
      log("IndustrialModel-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getTeeGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
    String areas = await AppConfig.instanceInit()?.loginData.user?.areas ?? "";
    try {
      Map<String, String> para = {"type": "Tee", "ga_id": gaId, "areas": areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json,
        context: context,
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getElbowGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        context: context,
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getCouplerGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        context: context,
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getReducerGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        context: context,
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getEndCapGisApi({
    required BuildContext context,
  }) async {
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        context: context,
      );
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
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        urlEndPoint: Apis.getPipelineNetwork + json,
        context: context,
      );
      if (res != null) {
        GetPipelineNetworkModel response = GetPipelineNetworkModel.fromJson(
          res,
        );
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
    String gaId = await AppConfig.instanceInit()?.gaId ?? "";
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
        urlEndPoint: Apis.getPipeline + json,
        context: context,
      );
      if (res != null) {
        PipelineModel response = PipelineModel.fromJson(res);
        if (await HiveDataBase.pipelineDataBox!.isOpen) {
          await HiveDataBase.pipelineDataBox!.clear();
          for (var data in response.data!) {
            await HiveDataBase.pipelineDataBox!.add(data);
          }
        }
        return response;
      }
    } catch (e) {
      log("getPipeline-->${e.toString()}");
    }
    return null;
  }

  static Future<List<String>?> getDiaColorApi({
    required BuildContext context,
  }) async {
    String? schema = AppConfig.instanceInit()?.loginData.user?.isHo == "1"
        ? AppConfig.instanceInit()?.hoSchema
        : AppConfig.instanceInit()?.loginData.user?.schema;

    Map<String, String> para = {"schema": schema ?? ""};
    String query = Uri(queryParameters: para).query;

    var res = await ApiHelper.getData(
      urlEndPoint: Apis.diaColor + query,
      context: context,
    );
    if (res != null && res["data"] != null) {
      final data = res["data"];
      if (data is Map<String, dynamic>) {
        return data.values.map((e) => e.toString()).toList();
      }
    }

    return null;
  }


  static Future<BitmapDescriptor> markerAsset(String path) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(28, 28)),
      path,
    );
  }

  static Set<Marker> markerPoint({
    required String assetId,
    required String assetsTypeId,
    required BitmapDescriptor icon,
    required LatLng position,
    required BuildContext context,
    required dynamic data,
  }) {
    Set<Marker> markersPointList = {};
    markersPointList.add(
      Marker(
        onTap: () {
          AppConfig.instanceInit()?.setAssets(assets: assetId);
          AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: assetsTypeId);
          AppConfig.instanceInit()?.setMarkerPoint(
            newPointMarkerLat: position.latitude.toString(),
            newPointMarkerLong: position.longitude.toString(),
          );
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: AlertDialogTwoBtnWidget(mContext: context,pipelineData: data,),
            ),
          );

        },
        markerId: MarkerId('$assetId-$assetsTypeId'),
        position: position,
        infoWindow: InfoWindow(
            title: assetsTypeId,
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
        width: 4,
        onTap: () {
          print("-------------------------------->polyline_$i");
          AppConfig.instanceInit()?.setAssets(assets: "");
          AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: "");
        },
      ),
    );
    return polylineList;
  }
  static Color getPolylineColor({required int value, required List<String> color}) {
    if (color.length < 4) {
      throw ArgumentError('color list must have at least 4 values');
    }

    if (value >= 0 && value <= 50) {
      return Color(int.parse(color[0]));
    } else if (value >= 63 && value <= 90) {
      return Color(int.parse(color[1]));
    } else if (value >= 100 && value <= 140) {
      return Color(int.parse(color[2]));
    } else if (value >= 150 && value <= 200) {
      return Color(int.parse(color[3]));
    } else {
      return Colors.blue.shade800; // default color
    }
  }

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


}
