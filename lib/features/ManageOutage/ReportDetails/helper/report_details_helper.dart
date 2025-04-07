import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentActionModel.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentActionProgressModel.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/consumer_affect_model.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';

class ReportDetailsHelper{

  static Future<IncidentActionModel?> getIncidentActionApi(
      {required BuildContext context, required String incidentTypeId}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
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
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
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
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "incidentId": incidentId,
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
    String userId = await SharedPref.getString(key: PrefsValue.userId);
    String schema = await SharedPref.getString(key: PrefsValue.schema);
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

}