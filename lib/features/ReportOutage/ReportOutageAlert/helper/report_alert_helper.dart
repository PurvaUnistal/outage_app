import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';

class ReportAlertHelper{

  static Future<GetPipelineGisModel?> getPipelineGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getPipelineGis, context: context);
      GetPipelineGisModel response = GetPipelineGisModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getGasValueGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getGasValueGis, context: context);
      GetTfGisModel response = GetTfGisModel.fromJson(res);
      return response;
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasValueGISModel?> getFittingGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getFittingGis, context: context);
      GetGasValueGISModel response = GetGasValueGISModel.fromJson(res);
      return response;
    } catch (e) {
      log("getFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getTFGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getTFGis, context: context);
      GetTfGisModel response = GetTfGisModel.fromJson(res);
      if(response.data != null){
        return response;
      }
    } catch (e) {
      log("getTFGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPipelineNetworkModel?> getPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    Map<String, String> para = {
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getPipelineNetwork + json, context: context);
      GetPipelineNetworkModel response = GetPipelineNetworkModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineNetwork-->${e.toString()}");
    }
    return null;
  }

  static  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}