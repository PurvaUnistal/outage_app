import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/service/Apis.dart';
import '../../../service/api_server_dio.dart';

class HoGridDashboardHelper{


  static Future<GridDataModel?> getGridDataApi({required BuildContext context}) async {
    String userId =  await AppConfig.instanceInit()?.loginData.user!.id ?? "";
    String gridId =  await AppConfig.instanceInit()?.loginData.user!.gaId ?? "";
    String schema =  await AppConfig.instanceInit()?.districtData.schema ?? "";
    String districtId =  await AppConfig.instanceInit()?.districtData.id ?? "";
    Map<String, String> para = {
      "schema": schema ?? "",
      "user_id": userId ?? "",
      // "grid_id": gridId ?? "",
      "district_id": districtId ?? "",

    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.gridData + json,context: context);
      if(res != null){
        GridDataModel response = GridDataModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("districtData-->${e.toString()}");
    }
    return null;
  }

}