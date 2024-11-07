import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_helper.dart';

import '../domain/model/GetAreaModel.dart';
import '../domain/model/GetChargeAreaModel.dart';

class CreateAlertFormHttpHelper{
  static Future<List<GetChargeAreaModel>?> getChargeAreaListApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getChargeAreaList +json, context: context);
      return getChargeAreaListModelFromJson(res);
    } catch (e) {
      log("getChargeAreaList-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetAreaModel>?> getAllAreaApi({required BuildContext context, required String gid}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
      "gid": gid,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getAllArea +json, context: context);
      if(res != null ){
        return getAreaListModelFromJson(res);
      }
    } catch (e) {
      log("getAllArea-->${e.toString()}");
    }
    return null;
  }
}