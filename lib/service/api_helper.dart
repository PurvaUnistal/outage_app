import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/common_session_dialog_box.dart';
import 'package:outage_app/Utils/common_widgets/connectivity_helper.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static Future<dynamic> getData({var urlEndPoint, required BuildContext context}) async {
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      String url = Apis.baseUrl + urlEndPoint;
      final res = await get(Uri.parse(url));
      log("URL :- ${url}");
      log("RES Body :- ${res.body}");
      if (res.statusCode == 200) {
        return res.body.toString();
      }
      if (res.statusCode == 400) {
        return res.body.toString();
      } else {
        log("Api.error-->${Api.error}");
        return null;
      }
    } catch (e) {
      log("ApiServer-->${e.toString()}");
      if (e is SocketException) {
        log("SocketException : ${e.toString()}");
        Utils.errorSnackBar(msg: "No Internet", context: context);
      } else if (e is TimeoutException) {
        log("TimeoutException : ${e.toString()}");
        Utils.errorSnackBar(msg: "Timeout, Please try again", context: context);
      } else {
        log("Unhandled exception : ${e.toString()}");
        Utils.errorSnackBar(msg: e.toString(), context: context);
      }
      return null;
    }
  }

  static Future<dynamic> postData({required String urlEndPoint, var body, required BuildContext context, Map<String, String>? headers}) async {
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      String url = Apis.baseUrl + urlEndPoint;
      var res = await post(Uri.parse(url), body: body,headers: headers);
      log("URL :- ${url}");
      log("RES Body :- ${res.body}");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 403) {
        return SessionDialogUtils.logOut(context: context);
      } else if (res.statusCode == 401) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 415) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print("catch--->" + e.toString());
      Utils.errorSnackBar(msg: e.toString(), context: context);
      return null;
    }
  }

  static Future<dynamic> postDataWithFile({
    var urlEndPoint,
    var body,
    required  List<ImageRequestObject> imageRequestObject,
    required BuildContext context
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = AppConfig.instanceInit()?.loginData.token??"";
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      Map<String, String> headers = {"Authorization": token};
      String url = Apis.baseUrl + urlEndPoint;
      var request = MultipartRequest("POST", Uri.parse(url));
      log("URL :- ${url}");
      log("RES fields :- ${request.fields}");
      log("RES files :- ${request.files}");
      for(int i=0; i< imageRequestObject.length ; i++) {
        var element = imageRequestObject[i];
        if (element.path!.isNotEmpty && !element.path!.startsWith("http")) {
          final mimeTypeData = lookupMimeType(element.path!, headerBytes: [0xFF, 0xD8])!.split('/');
          var file = await MultipartFile.fromPath(element.key!, element.path!, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          request.files.add(file);
        } else {
          body[element.key] = element.path;
        }
      }
      request.fields.addAll(body);
      request.headers.addAll(headers);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = json.decode(String.fromCharCodes(responseData));
      if (response.statusCode == 200) {
        log("result-->${result.toString()}");
        return result;
      } else if (response.statusCode == 401) {
        log("result-->${result.toString()}");
        return result;
      } else if (response.statusCode == 415) {
        Utils.errorSnackBar(msg: result['data'].toString(), context:context);
        log(result['data'].toString());
        return null;
      } else if (response.statusCode == 400) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      log("postDataWithFile-->${e.toString()}");
      return null;
    }
  }

  static Future<bool> isInternetConnected() async {
    bool isConnect = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnect = true;
      }
    } on SocketException catch (_) {}

    return isConnect;
  }
}

enum Api { error }

class ImageRequestObject {
  String? key;
  String? path;

  ImageRequestObject(this.key, this.path);
}