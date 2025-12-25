import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/secrets.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/EmergencyModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/IndustrialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/ValveGISModel.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';
import 'package:path_provider/path_provider.dart';

class IncidentReportHelper {

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

  static Future<PipelineModel?> getPipelineApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
        "latitude": latitude,
        "longitude": longitude,
        "buffer": "3",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getPipeline + json, context: context);
      log("HO User: ${ctx.isHo}");
      if (res != null && res["data"] != null &&  res["data"] is List) {
        final response = PipelineModel.fromJson(res);
        if (!ctx.isHo) {
          final box = HiveDataBase.pipelineDataBox;
          if (box?.isOpen ?? false) {
            await box!.clear();
            await box.addAll(response.data!);
          }
        }
        return response;
        // if(ctx.isHo){
        //   await HiveDataBase.pipelineDataBox!.clear();
        //   return response;
        // }else{
        //   if (await HiveDataBase.pipelineDataBox!.isOpen) {
        //     await HiveDataBase.pipelineDataBox!.clear();
        //     await HiveDataBase.pipelineDataBox!.addAll(response.data!);
        //   }
        //   return response;
        // }
      }else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("getPipeline-->${e.toString()}");
    }
    return null;
  }


  static Future<TFGISModel?> getTFGisApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {
      log("HO User: ${ctx.isHo}");
      final query = Uri(queryParameters: {"ga_id": ctx.gaId, "areas": ctx.areas}).query;
      final res = await ApiHelper.getData(urlEndPoint: Apis.getTFGis + query,context: context);
      print("--------------->${ Apis.getTFGis + query}");
      if(res != null && res["data"] != null &&  res["data"] is List){
        print("ctx.isHo--->${ctx.isHo}");
        TFGISModel? response = TFGISModel.fromJson(res);
        if (ctx.isHo) {
          if (HiveDataBase.tfGISBox != null) {
            await HiveDataBase.tfGISBox!.clear();
          }
          return response;
        } else {
          if (HiveDataBase.tfGISBox != null && await HiveDataBase.tfGISBox!.isOpen) {
            await HiveDataBase.tfGISBox!.clear();
            if (response.data != null) {
              await HiveDataBase.tfGISBox!.addAll(response.data!);
            }
          }
          return response;
        }
      } else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("getTFGis --> ${e.toString()}");
      return null;
    }
    return null;
  }

  static Future<ValveGISModel?> getGasValueGisApi({ required BuildContext context,}) async {
    final ctx = UserContext.getUserContext();
    try {
      String json = Uri(queryParameters: {"ga_id": ctx.gaId, "areas": ctx.areas}).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getGasValueGis + json,context: context
      );
    if (res != null && res["data"] != null && res["data"] is List) {
      ValveGISModel? response = ValveGISModel.fromJson(res);

      if (ctx.isHo) {
        if (HiveDataBase.valveGISBox != null) {
          await HiveDataBase.valveGISBox!.clear();
        }
        return response;
      } else {
        if (HiveDataBase.valveGISBox != null && await HiveDataBase.valveGISBox!.isOpen) {
          await HiveDataBase.valveGISBox!.clear();
          if (response.data != null) {
            await HiveDataBase.valveGISBox!.addAll(response.data!);
          }
        }
        return response;
      }
    } else if (res != null && res["data"] != null && res["data"] is String) {
      await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
      return null;
    }
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<RegulatorGISModel?> getRegulatorGisApi({ required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {
      String json = Uri(queryParameters: {"ga_id": ctx.gaId, "areas": ctx.areas}).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getRegulatorGis + json,context: context);
      if (res != null && res["data"] != null &&  res["data"] is List) {
        RegulatorGISModel response = RegulatorGISModel.fromJson(res);
        if (ctx.isHo) {
          if (HiveDataBase.regulatorGISBox != null) {
            await HiveDataBase.regulatorGISBox!.clear();
          }
          return response;
        } else {
          if (HiveDataBase.regulatorGISBox != null && await HiveDataBase.regulatorGISBox!.isOpen) {
            await HiveDataBase.regulatorGISBox!.clear();
            if (response.data != null) {
              await HiveDataBase.regulatorGISBox!.addAll(response.data!);
            }
          }
          return response;
        }
      }else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("getRegulatorGis-->${e.toString()}");
    }
    return null;
  }

  static Future<CommercialModel?> getCommercialApi({ required BuildContext context,}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "schema": ctx.schema,
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
        "type": "1",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getConsumerGis + json,context: context);
      if (res != null && res["data"] != null &&  res["data"] is List) {
        CommercialModel response = CommercialModel.fromJson(res);
        if (ctx.isHo) {
          if (HiveDataBase.commercialDataBox != null) {
            await HiveDataBase.commercialDataBox!.clear();
          }
          return response;
        } else {
          if (HiveDataBase.commercialDataBox != null && await HiveDataBase.commercialDataBox!.isOpen) {
            await HiveDataBase.commercialDataBox!.clear();
            if (response.data != null) {
              await HiveDataBase.commercialDataBox!.addAll(response.data!);
            }
          }
          return response;
        }
      }else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("getConsumerGis-->${e.toString()}");
    }
    return null;
  }

  static Future<DomesticModel?> getDomesticApi({ required BuildContext context,}) async {
    final ctx = UserContext.getUserContext();
      try {
      Map<String, String> para = {
        "schema": ctx.schema,
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
        "type": "2",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getConsumerGis + json,context: context
      );
      if (res != null && res["data"] != null &&  res["data"] is List) {
        DomesticModel response = DomesticModel.fromJson(res);
        if (ctx.isHo) {
          if (HiveDataBase.domesticDataBox != null) {
            await HiveDataBase.domesticDataBox!.clear();
          }
          return response;
        } else {
          if (HiveDataBase.domesticDataBox != null && await HiveDataBase.domesticDataBox!.isOpen) {
            await HiveDataBase.domesticDataBox!.clear();
            if (response.data != null) {
              await HiveDataBase.domesticDataBox!.addAll(response.data!);
            }
          }
          return response;
        }
      }else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("DomesticModel-->${e.toString()}");
    }
    return null;
  }

  static Future<IndustrialModel?> getIndustrialApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "schema": ctx.schema,
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
        "type": "3",
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getConsumerGis + json,context: context
      );
      if (res != null && res["data"] != null &&  res["data"] is List) {
        IndustrialModel response = IndustrialModel.fromJson(res);

        if (ctx.isHo) {
          if (HiveDataBase.industrialDataBox != null) {
            await HiveDataBase.industrialDataBox!.clear();
          }
          return response;
        } else {
          if (HiveDataBase.industrialDataBox != null && await HiveDataBase.industrialDataBox!.isOpen) {
            await HiveDataBase.industrialDataBox!.clear();
            if (response.data != null) {
              await HiveDataBase.industrialDataBox!.addAll(response.data!);
            }
          }
          return response;
        }
      } else if(res != null && res["data"] != null &&  res["data"] is String){
        await Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      log("IndustrialModel-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasValueGISModel?> getFittingGisApi({ required BuildContext context,}) async {
    try {
      final ctx = UserContext.getUserContext();

      Map<String, String> para = {"ga_id": ctx.gaId, "areas": ctx.areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getFittingGis + json,context: context);
      if (res != null) {
        GetGasValueGISModel response = GetGasValueGISModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getTeeGisApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {"type": "Tee", "ga_id": ctx.gaId, "areas": ctx.areas};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json,context: context
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getNonControllableFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getElbowGisApi({ required BuildContext context,}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "type": "Elbow",
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json,context: context
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getNonControllableFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getCouplerGisApi({ required BuildContext context}) async {
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> para = {
        "type": "Coupler",
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json,context: context
      );
      if (res != null) {
        GetGasGisModel response = GetGasGisModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getNonControllableFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasGisModel?> getReducerGisApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> para = {
        "type": "Reducer",
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json, context: context
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

  static Future<GetGasGisModel?> getEndCapGisApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "type": "End Cap",
        "ga_id": ctx.gaId,
        "areas": ctx.areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getNonControllableFittingGis + json,context: context
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
    required String latitude,
    required String longitude,
    required BuildContext context,
  }) async {
    final ctx = UserContext.getUserContext();

    Map<String, String> para = {
      "ga_id": ctx.gaId,
      "areas": ctx.areas,
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      log(Apis.getPipelineNetwork + json);
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getPipelineNetwork + json,context: context
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


  static Future<List<String>?> getDiaColorApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    String query = Uri(queryParameters: {"schema": ctx.schema}).query;
    var res = await ApiHelper.getData(urlEndPoint: Apis.diaColor + query,context: context);
    if (res != null && res["data"] != null) {
      final data = res["data"];
      if (data is Map<String, dynamic>) {
        return data.values.map((e) => e.toString()).toList();
      }
    }
    return null;
  }

  static Future<EmergencyModel?> getEmergencySearchApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> para = {"district_id": ctx.gaId, "search": "Hospital"};
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(
        urlEndPoint: Apis.emergencySearch + json, context: context
      );
      if (res != null) {
        EmergencyModel response = EmergencyModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("EmergencyModel-->${e.toString()}");
    }
    return null;
  }

  static  getSuggestion({required String input,}) async {
    const String PLACES_API_KEY = Secrets.API_KEY;
    var uuid = const Uuid();
    String sessionToken = uuid.v4();
    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$sessionToken';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['predictions'] ?? [];
      } else {
        throw Exception('Failed to load predictions');
      }
    }catch(e){
      print(e);
    }

  }
}
