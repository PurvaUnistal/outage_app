import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_helper.dart';
import '../domain/model/GetAreaModel.dart';
import '../domain/model/GetChargeAreaModel.dart';

class CreateAlertFormHttpHelper{
  static Future<List<GetChargeAreaModel>?> getChargeAreaListApi({required BuildContext context}) async {
    final ctx = UserContext.getUserContext();
    try {

      Map<String, String> para = {
        "schema": ctx.schema,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getChargeAreaList +json, context: context);
      return getChargeAreaListModelFromJson(res);
    } catch (e) {
      log("getChargeAreaList-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetAreaModel>?> getAllAreaApi({required BuildContext context, required String gid}) async {
    final ctx = UserContext.getUserContext();
    try {
      Map<String, String> para = {
        "schema": ctx.schema,
        "gid": ctx.areas,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getAllArea +json,context: context);
      if(res != null ){
        return getAreaListModelFromJson(res);
      }
    } catch (e) {
      log("getAllArea-->${e.toString()}");
    }
    return null;
  }
}