import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';
import '../domain/model/ViewIncidentModel.dart';

class ManageAlertHelper{

  static Future<ViewIncidentModel?> getViewIncidentApi(
      {required BuildContext context}) async {
    String schema = await AppConfig.instanceInit()?.loginData.user?.schema! ?? "";
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getViewIncident + json, context: context);
      ViewIncidentModel response = ViewIncidentModel.fromJson(res);
      return response;
    } catch (e) {
      log("getViewIncident-->${e.toString()}");
    }
    return null;
  }



}