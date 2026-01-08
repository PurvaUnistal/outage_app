import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';

class LoginHelper {



  static Future<dynamic> textFieldValidation({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      if (email.isEmpty) {
        Utils.errorSnackBar(msg: AppString.emailValidation,context: context);
        return false;
      } else if (password.isEmpty) {
        Utils.errorSnackBar(
          msg: AppString.passwordValidation,context: context
        );
        return false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      Utils.errorSnackBar(msg: e.toString(),context: context);
      return false;
    }
  }

  static getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }

  static Future<LoginModel?> loginData({
    required String emailId,
    required String password,
    required BuildContext context
  }) async {
    var deviceId = await getUniqueDeviceId();
    Map<String, String> para = {
      "email": emailId,
      "password": password,
      "deviceId": deviceId.toString(),
    };
   try {
      var res = await ApiHelper.postData(
        urlEndPoint: Apis.loginUrl,
        param: para,
        context: context,
      );
      if (res != null && res["error"] == false) {
        if (res["user"]["role"] == "outage management" ||
            res["user"]["role"] == "incident" ||
            res["user"]["role"] == "technician" ||
            res["user"]["role"] == "onmengineer" ||
            res["user"]["role"] == "Manager") {
          await Utils.successSnackBar(msg: res["messages"],context: context);
          String baseUrl = Apis.loginUrl.replaceAll("api/auth", "");
          AppConfig.instanceInit()?.setBaseURL(baseURL: baseUrl);
          print(baseUrl);
          return LoginModel.fromJson(res);
        } else {
          await Utils.errorSnackBar(
            msg: "Invalid role ID. Please check your credentials.",context: context
          );
        }
      } else if (res != null && res["error"] == true) {
        await Utils.errorSnackBar(msg: res["messages"], context: context);
        return null;
      } else {
        await Utils.errorSnackBar(msg: res["messages"],context: context);
        return null;
      }
    } catch (e) {
      log("catchLoginHelper --> ${e.toString()}");
      //  await Utils.errorSnackBar(msg: e.toString(), context: context);
      return null;
    }
    return null;
  }
}
