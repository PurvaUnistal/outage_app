import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/connectivity_helper.dart';
import 'package:outage_app/service/Apis.dart';

class ApiHelper {
  static Future<dynamic> getData({
    required String urlEndPoint,
    required BuildContext context,
  }) async {
    try {
      if (!await ConnectivityHelper.allConnectivityCheck(context: context)) {
        return null;
      }
      String url = Apis.baseUrl + urlEndPoint;
      final response = await Dio().get(Uri.parse(url).toString());
      log("URL --> $url");
      log("Response Data --> ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (error) {
      debugPrint("Dio Error --> ${error.message}");
      final statusCode = error.response?.statusCode;
      final errorMessage = error.response?.data?.toString() ?? "Unknown Error";
      if (statusCode == 400) {
        await Utils.errorSnackBar(
            msg: errorMessage.replaceAll("{", "").replaceAll("}", ""),
            context: context);
        return error.response!.data;
      } else {
        await _handleError(statusCode, errorMessage, context);
      }
    } catch (e) {
      log("Catch Error --> $e");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }

  static Future<dynamic> postData({
    required BuildContext context,
    required String urlEndPoint,
    Map<String, dynamic>? param,
    Map<String, String>? headers,
    String? contentType,
    formData,
  }) async {
    try {
      if (!await ConnectivityHelper.allConnectivityCheck(context: context)) {
        return null;
      }
      String url = Apis.baseUrl + urlEndPoint;
      var options = Options(
        headers: headers ?? {},
        contentType:
            contentType ?? (formData != null ? "multipart/form-data" : null),
      );
      var res = await Dio().post(Uri.parse(url).toString(),
          options: options, data: param ?? FormData.fromMap(formData));
      log("URL :- ${url}");
      log("RES Data :- ${res.data}");
      if (res.statusCode == 200) {
        return res.data;
      } else {
        return res.data;
      }
    } on DioException catch (error) {
      debugPrint("Dio Error --> ${error.message}");
      final statusCode = error.response?.statusCode;
      final errorMessage = error.response?.data?.toString() ?? "Unknown Error";
      if (statusCode == 400) {
        await Utils.errorSnackBar(
            msg: errorMessage.replaceAll("{", "").replaceAll("}", ""),
            context: context);
        return error.response!.data;
      } else {
        await _handleError(statusCode, errorMessage, context);
      }
    } catch (e) {
      log("Multipart Error --> $e");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }

  static Future<dynamic> postDataWithFile({
    required String urlEndPoint,
    required Map<String, dynamic> body,
    required List<ImageRequestObject> imageRequestObject,
    required BuildContext context,
  }) async {
    try {
      if (!await ConnectivityHelper.allConnectivityCheck(context: context)) {
        return null;
      }
      final formData = FormData.fromMap(body);
      for (var element in imageRequestObject) {
        if (element.path!.isNotEmpty && !element.path!.startsWith("http")) {
          final mimeTypeData =
              lookupMimeType(element.path!, headerBytes: [0xFF, 0xD8])
                  ?.split('/');
          if (mimeTypeData != null && mimeTypeData.length == 2) {
            formData.files.add(
              MapEntry(
                element.key!,
                await MultipartFile.fromFile(
                  element.path!,
                  contentType: DioMediaType(mimeTypeData[0], mimeTypeData[1]),
                ),
              ),
            );
          }
        } else {
          body[element.key!] = element.path;
        }
      }

      String url = Apis.baseUrl + urlEndPoint;
      final response =
          await Dio().post(Uri.parse(url).toString(), data: formData);
      debugPrint("URL --> $url");
      debugPrint("Response Data --> ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (error) {
      debugPrint("Dio Error --> ${error.message}");
      final statusCode = error.response?.statusCode;
      final errorMessage = error.response?.data?.toString() ?? "Unknown Error";
      if (statusCode == 400) {
        await Utils.errorSnackBar(
            msg: errorMessage.replaceAll("{", "").replaceAll("}", ""),
            context: context);
        return error.response!.data;
      } else {
        await _handleError(statusCode, errorMessage, context);
      }
    } catch (e) {
      debugPrint("Multipart Error --> $e");
      await Utils.errorSnackBar(msg: "Something Went Wrong", context: context);
      throw 'Something Went Wrong';
    }
  }

  static Future<void> _handleError(
      int? statusCode, String errorMessage, BuildContext context) async {
    switch (statusCode) {
      case 400:
      case 404:
      case 415:
      case 500:
        await Utils.errorSnackBar(
            msg: errorMessage.replaceAll("{", "").replaceAll("}", ""),
            context: context);
        break;
      default:
        await Utils.errorSnackBar(
            msg: "Unexpected Error: $errorMessage", context: context);
        break;
    }
  }
}

class ImageRequestObject {
  String? key;
  String? path;

  ImageRequestObject(this.key, this.path);
}
