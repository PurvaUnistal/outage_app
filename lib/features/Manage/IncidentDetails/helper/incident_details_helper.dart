import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentActionProgressModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/consumer_affect_model.dart';
import 'package:outage_app/service/Apis.dart';
import 'package:outage_app/service/api_server_dio.dart';

class IncidentDetailHelper{

  static Future<IncidentActionModel?> getIncidentActionApi({required BuildContext context,required String incidentTypeId}) async {
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> para = {
        "schema": ctx.schema ,
        "incident_type_id": incidentTypeId,
      };
      String json = Uri(queryParameters: para).query;
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentAction + json, context: context);
      if(res != null){
        IncidentActionModel response = IncidentActionModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

  static Future<IncidentTypeActionModel?> getIncidentTypeActionApi({
        required BuildContext context,
        required String incidentTypeId,
        required String incidentId,
  }) async {
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> para = {
        "schema": ctx.schema,
        "incident_type_id": incidentTypeId,
        "incident_id": incidentId,
      };

      String json = Uri(queryParameters: para).query;
      print("Apis.getIncidentTypeAction + json-->${Apis.getIncidentTypeAction + json}");
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentTypeAction + json, context: context);
      if(res != null){
        IncidentTypeActionModel response = IncidentTypeActionModel.fromJson(res);
        return response;
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

  static Future<ConsumerAffectModel?> getValveConsumerAffectApi({
    required BuildContext context,
    required String incidentId,
  }) async {
    try {
      final ctx = UserContext.getUserContext();
      Map<String, String> para = {
        "schema": ctx.schema,
        "incidentId": incidentId,
        "district_id": ctx.gaId,
      };
      String json = Uri(queryParameters: para).query;
      print("API URL: ${Apis.getValveConsumerAffect + json}");

      var res = await ApiHelper.getData(
        urlEndPoint: Apis.getValveConsumerAffect + json,
        context: context,
      );
      if (res is Map<String, dynamic>) {
        return ConsumerAffectModel.fromJson(res);
      } else if (res is List && res.isNotEmpty && res[0] is Map<String, dynamic>) {
        // ✅ API is returning a list instead of a map
        return ConsumerAffectModel.fromJson(res[0]);
      } else {
        log("Unsupported response structure: ${res.runtimeType}");
        return null;
      }
    } catch (e, stacktrace) {
      log("getValveConsumerAffect-->${e.toString()}");
      log(stacktrace.toString());
      return null;
    }
  }

  Future<void> _processMarkersInBatches({
    required List<LatLng> positions,
    required BuildContext context,
    required BitmapDescriptor icon,
    required Function(Marker) onMarkerCreated,
    Function()? onTap,
    int batchSize = 50,
  }) async {
    for (int i = 0; i < positions.length; i += batchSize) {
      final batch = positions.skip(i).take(batchSize);

      final markers = await Future.wait(batch.map((pos) async {
        return Marker(
          markerId: MarkerId('${pos.latitude},${pos.longitude}'),
          position: pos,
          icon: icon,
          onTap: onTap,
        );
      }));

      for (final marker in markers) {
        onMarkerCreated(marker);
      }

      // Optional pause to allow UI thread to breathe
      await Future.delayed(Duration(milliseconds: 50));
    }
  }


  static Future<IncidentActionProgressModel?> incidentActionProgressApi({
    required BuildContext context,
    required String incidentId,
    required String incidentTypeId,
    required String incidentActionId,
    required String status,
    required String row,
  }) async {
    String userId = await AppConfig.instanceInit()?.loginData.user?.id ?? "";
    final ctx = UserContext.getUserContext();

    try {
      Map<String, String> body = {
        "schema": ctx.schema,
        "user_id": userId,
        "incident_id": incidentId.isEmpty ? "" :incidentId.toString(),
        "incident_type_id": incidentTypeId.isEmpty ? "" :incidentTypeId.toString(),
        "incident_action_id": incidentActionId.isEmpty ? "" : incidentActionId.toString(),
        "status": status.isEmpty ? "" : status.toString(),
        "row": row.isEmpty ? "" : row.toString(),

      };
      log("jsonBody-->${body}");
      log("Apis.incidentActionProgress-->${Apis.incidentActionProgress}");
      var res = await ApiHelper.postData(urlEndPoint: "${Apis.incidentActionProgress}", formData: body, context: context);
      if(res != null){
        return IncidentActionProgressModel.fromJson(res);
      }
    } catch (e) {
      log("IncidentActionModel-->${e.toString()}");
    }
    return null;
  }

 static LatLng? parseLatLng(String? lat, String? lng) {
    double? latitude = double.tryParse(lat ?? '');
    double? longitude = double.tryParse(lng ?? '');
    return (latitude != null && longitude != null)
        ? LatLng(latitude, longitude)
        : null;
  }

  static List<LatLng> getLatLngList(List<dynamic> dataList) {
    return dataList
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) =>
        LatLng(double.parse(data.latitude!), double.parse(data.longitude!)))
        .toList();
  }


static  Widget row({required String title, required String subtitle}){
    return   Row(
      children: [
        Text(
          "${title} : ",
          style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }
}