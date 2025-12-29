import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/features/InChargeDashboard/domain/model/InChargeDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/service/Apis.dart';
import '../../../service/api_server_dio.dart';

class InChargeDashboardHelper{

  static Future<InChargeDataModel?> getInChargeDataApi({required BuildContext context}) async {

    LoginModel?  loginData =  await AppConfig.instanceInit()?.loginData;

    DistrictData? districtData =  await AppConfig.instanceInit()?.districtData;
    String gridID =  await AppConfig.instanceInit()?.gridData.id ?? "";


    try {
      final Map<String, String> para = {
        "schema": loginData!.user!.isHo == "1" ? districtData!.schema.toString() : loginData.user!.schema.toString(),
        "user_id": loginData.user!.id.toString(),
        "grid_id": loginData.user!.isHo == "1" ? gridID : loginData.user!.gaId.toString(),
        "district_id": loginData.user!.isHo == "1" ? districtData!.id.toString() : loginData.user!.areas.toString(),
        "role": loginData.user!.role.toString(),
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