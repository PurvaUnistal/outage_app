import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/InChargeDashboard/domain/model/InChargeDataModel.dart';
import 'package:outage_app/service/Apis.dart';
import '../../../service/api_server_dio.dart';

class InChargeDashboardHelper{

  static Future<InChargeDataModel?> getInChargeDataApi({required BuildContext context}) async {
    final appConfig = AppConfig.instanceInit();
    final user = appConfig?.loginData.user;

    final String userId = user?.id ?? "";
    final String role = user?.role ?? "";

    final ctx = UserContext.getUserContext();

    try {
      final Map<String, String> para = {
        "schema": ctx.schema,
        "user_id": userId,
        "grid_id": ctx.gaId,
        "district_id": ctx.areas,
        "role": role,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.inChargeData + json,context: context);
      if(res != null){
        InChargeDataModel response = InChargeDataModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("InChargeDataModel-->${e.toString()}");
    }
    return null;
  }
}