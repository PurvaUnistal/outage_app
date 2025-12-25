import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/service/Apis.dart';
import '../../../service/api_server_dio.dart';

class HoDistrictDashboardHelper {

  static Future<DistrictDataModel?> getDistrictDataApi({required BuildContext context}) async {
    String userId = await AppConfig.instanceInit()?.loginData.user!.id ?? "";
    Map<String, String> para = {"user_id": userId ?? ""};
    String json = Uri(queryParameters: para).query;
   // try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.districtData + json,context: context);
      if (res != null) {
        DistrictDataModel response = DistrictDataModel.fromJson(res);
        return response;
      }
    // } catch (e) {
    //   log("districtData-->${e.toString()}");
    // }
    return null;
  }
}
