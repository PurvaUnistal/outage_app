import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/connectivity_helper.dart';

class ApiHelper {
  static Future<dynamic> getData({var urlEndPoint, required BuildContext context}) async {
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      final res = await Dio().get(urlEndPoint);
      log("url-->${urlEndPoint}");
      log("resData-->${res.data}");
      if (res.statusCode == 200) {
        return res.data;
      }else {
        return res.data;
      }
    } on DioException catch (error) {
      log(error.message!);
      if(error.response?.statusCode == 400){
        return error.response!.data;
      }else if(error.response?.statusCode == 401){
        log("errorStatus(401)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 404){
        log("errorStatus(404)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 415){
        return await Utils.errorSnackBar(msg: error.response!.data["data"].toString(), context: context);
      } else if(error.response?.statusCode == 500){
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      } else{
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }
    }catch (e) {
      log("catchGET-->${e.toString()}");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }

  static Future<dynamic> postData({
        required BuildContext context,
        required String urlEndPoint,
        Map<String, dynamic>? param,
        String? contentType,
        formData,
      }) async {
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      var response = await Dio().post(urlEndPoint, data: param ?? FormData.fromMap(formData));
      log("url-->${urlEndPoint}");
      log("resData-->${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      }else{
        return response.data;
      }
    } on DioException catch (error) {
      log(error.message!);
      if(error.response?.statusCode == 400){
        return error.response!.data;
      }else if(error.response?.statusCode == 401){
        log("errorStatus(401)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 404){
        log("errorStatus(404)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 415){
        return await Utils.errorSnackBar(msg: error.response!.data["data"].toString(), context: context);
      } else if(error.response?.statusCode == 500){
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      } else{
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }
    }catch (e) {
      log("MultipartFile-->${e.toString()}");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }

  static Future<dynamic> postDataWithFile({
    var urlEndPoint,
    var body,
    required List<ImageRequestObject> imageRequestObject,
    required BuildContext context
  }) async {
    try {
      if(await ConnectivityHelper.allConnectivityCheck(context: context) == false){
        return null;
      }
      final formData = FormData.fromMap(body);
      for(int i=0; i< imageRequestObject.length ; i++) {
        var element = imageRequestObject[i];
        if (element.path!.isNotEmpty && !element.path!.startsWith("http")) {
          final mimeTypeData = lookupMimeType(element.path!, headerBytes: [0xFF, 0xD8])!.split('/');
          formData.files.add(
            MapEntry(element.key!, await MultipartFile.fromFile(element.path!, contentType:DioMediaType(mimeTypeData[0], mimeTypeData[1]) )),
          );
        } else {
          body[element.key!] = element.path;
        }
      }
      final response = await Dio().post(urlEndPoint, data: formData,);
      log("url-->${urlEndPoint}");
      log("resData-->${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (error) {
      log(error.message!);
      if(error.response?.statusCode == 400){
        return error.response!.data;
      }else if(error.response?.statusCode == 401){
        log("errorStatus(401)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 404){
        log("errorStatus(404)-->${error.response!.statusMessage!.toString()}");
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }else if(error.response?.statusCode == 415){
        return await Utils.errorSnackBar(msg: error.response!.data["data"].toString(), context: context);
      } else if(error.response?.statusCode == 500){
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      } else{
        return await Utils.errorSnackBar(msg: error.response!.statusMessage!.toString(), context: context);
      }
    }catch (e) {
      log("MultipartFile-->${e.toString()}");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }
}


class ImageRequestObject {
  String? key;
  String? path;

  ImageRequestObject(this.key, this.path);
}