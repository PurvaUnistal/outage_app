import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';
import '../domain/model/ViewIncidentModel.dart';

class ManageAlertHelper{

  static Future<ViewIncidentModel?> getViewIncidentApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
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