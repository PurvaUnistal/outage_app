import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentActionProgressModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/consumer_affect_model.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';

class IncidentDetailHelper{

  static Future<IncidentActionModel?> getIncidentActionApi(
      {required BuildContext context, required String incidentTypeId}) async {
    String schema = await AppConfig.instanceInit()?.loginData.user?.schema ?? "";
    String gaId =  await AppConfig.instanceInit()?.gaId ?? "";
    Map<String, String> para = {
      "schema": schema,
      "incident_type_id": incidentTypeId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentAction + json, context: context);
      if(res != null){
        IncidentActionModel response = IncidentActionModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

  static Future<IncidentTypeActionModel?> getIncidentTypeActionApi({
    required BuildContext context,
        required String incidentTypeId,
        required String incidentId,
  }) async {
    String schema = await AppConfig.instanceInit()?.loginData.user?.schema ?? "";
    Map<String, String> para = {
      "schema": schema,
      "incident_type_id": incidentTypeId,
      "incident_id": incidentId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentTypeAction + json, context: context);
      if(res != null){
        IncidentTypeActionModel response = IncidentTypeActionModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

  static Future<ConsumerAffectModel?> getValveConsumerAffectApi({
    required BuildContext context,
    required String incidentId,
  }) async {
    String schema =await AppConfig.instanceInit()?.loginData.user?.schema ?? "";
    String gaId =  await AppConfig.instanceInit()?.gaId ?? "";
    Map<String, String> para = {
      "schema": schema,
      "incidentId": incidentId,
      "district_id": gaId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getValveConsumerAffect + json, context: context);
      if(res != null){
        ConsumerAffectModel response = ConsumerAffectModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("getValveConsumerAffect-->${e.toString()}");
    }
    return null;
  }

  static Future<IncidentActionProgressModel?> incidentActionProgressApi({
    required BuildContext context,
    required String incidentId,
    required String incidentTypeId,
    required String incidentActionId,
    required String status,
    required String row,
  }) async {
    String userId = await AppConfig.instanceInit()?.loginData.user?.id ?? "";
    String schema = await AppConfig.instanceInit()?.loginData.user?.schema ?? "";
    Map<String, String> body = {
      "schema": schema,
      "user_id": userId,
      "incident_id": incidentId.isEmpty ? "" :incidentId.toString(),
      "incident_type_id": incidentTypeId.isEmpty ? "" :incidentTypeId.toString(),
      "incident_action_id": incidentActionId.isEmpty ? "" : incidentActionId.toString(),
      "status": status.isEmpty ? "" : status.toString(),
      "row": row.isEmpty ? "" : row.toString(),

    };
    log("jsonBody-->${body}");
    log("Apis.incidentActionProgress-->${Apis.incidentActionProgress}");
    try {
      var res = await ApiHelper.postData(urlEndPoint: "${Apis.incidentActionProgress}", formData: body, context: context,);
      if(res != null){
        return IncidentActionProgressModel.fromJson(res);
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

 static LatLng? parseLatLng(String? lat, String? lng) {
    double? latitude = double.tryParse(lat ?? '');
    double? longitude = double.tryParse(lng ?? '');
    return (latitude != null && longitude != null)
        ? LatLng(latitude, longitude)
        : null;
  }

  static List<LatLng> getLatLngList(List<dynamic> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
        LatLng(double.parse(data.latitude!), double.parse(data.longitude!)))
        .toList();
  }

}