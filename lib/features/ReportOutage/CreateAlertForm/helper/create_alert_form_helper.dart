import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetLocationSourceModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetPriorityTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';
import '../domain/model/AddIncidentModel.dart';
import '../domain/model/GetAreaModel.dart';
import '../domain/model/GetAssetModel.dart';
import '../domain/model/GetChargeAreaModel.dart';
import '../domain/model/GetControlRoomModel.dart';
import '../domain/model/GetCustomerLocationModel.dart';
import '../domain/model/GetIncidentIndicationModel.dart';
import '../domain/model/GetViewIncidentModel.dart';

class CreateAlertFormHelper {
  static Future<GetModuleTypeModel?> getOutageModuleApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getOutageModule + json, context: context);
      GetModuleTypeModel response = GetModuleTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getOutageModule-->${e.toString()}");
    }
    return null;
  }

  static Future<GetIncidentTypeModel?> getIncidentTypeApi(
      {required BuildContext context, required String moduleId}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "module_id": moduleId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getIncidentType + json, context: context);
      GetIncidentTypeModel response = GetIncidentTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentType-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPriorityTypeModel?> getIncidentPriorityApi(
      {required BuildContext context, required String moduleId}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "module_id": moduleId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getIncidentPriority + json, context: context);
      GetPriorityTypeModel response = GetPriorityTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentPriority-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetLocationSourceModel>?> getLocationSourceApi(
      {required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getLocationSource, context: context);
      return GetLocationSourceModel.mapToList(res["data"]);
    } catch (e) {
      log("getLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPriorityTypeModel?> getInformationSourceApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getInformationSource + json, context: context);
      GetPriorityTypeModel response = GetPriorityTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getInformationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetIncidentIndicationModel?> getIncidentIndicationApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getIncidentIndication + json, context: context);
      GetIncidentIndicationModel response =
          GetIncidentIndicationModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentIndication-->${e.toString()}");
    }
    return null;
  }

  static Future<ViewIncidentModel?> getViewIncidentApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getViewIncident + json, context: context);
      ViewIncidentModel response = ViewIncidentModel.fromJson(res);
      return response;
    } catch (e) {
      log("getViewIncident-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetLocationSourceModel>?> getCustomerLocationSourceApi(
      {required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getCustomerLocationSource, context: context);
      return GetLocationSourceModel.mapToList(res["data"]);
    } catch (e) {
      log("getCustomerLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetAssetModel?> getAssetLocationSourceApi(
      {required BuildContext context}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getAssetLocationSource + json, context: context);
      GetAssetModel response = GetAssetModel.fromJson(res);
      return response;
    } catch (e) {
      log("getAssetLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetCustomerLocationModel?> getCustomerDetailByLocationApi(
      {required BuildContext context,
      required String locationSource,
      required String search}) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "location_source": locationSource,
      "serach": search,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getCustomerDetailByLocation + json,
          context: context);
      GetCustomerLocationModel response =
          GetCustomerLocationModel.fromJson(res);
      return response;
    } catch (e) {
      log("getCustomerDetailByLocation-->${e.toString()}");
    }
    return null;
  }

  static Future<GetControlRoomModel?> getControlRoomApi({
    required BuildContext context,
    required String areaId,
  }) async {
    String schema = await SharedPref.getString(
      key: PrefsValue.schema,
    );
    Map<String, String> para = {
      "schema": schema,
      "area_id": areaId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(
          urlEndPoint: Apis.getControlRoom + json, context: context);
      GetControlRoomModel response = GetControlRoomModel.fromJson(res);
      return response;
    } catch (e) {
      log("getControlRoom-->${e.toString()}");
    }
    return null;
  }

  static Future<dynamic> validationSubmit({
    required BuildContext context,
    required GetIncidentTypeData incidentType,
    required String asset,
    required String assetId,
    required String address,
    required String landmark,
    required GetIncidentIndicationData incidentIndication,
    required File photo,
  }) async {
    try {
      if (incidentType.id == null) {
        Utils.errorSnackBar(
            msg: "The Incident Type field is required.", context: context);
        return false;
      } else if (asset.isEmpty) {
        Utils.errorSnackBar(
            msg: "The Asset Type Id is required.", context: context);
        return false;
      } else if (address.isEmpty) {
        Utils.errorSnackBar(
            msg: "The Address field is required.", context: context);
        return false;
      } else if (landmark.isEmpty) {
        Utils.errorSnackBar(
            msg: "The Landmark field is required.", context: context);
        return false;
      } else if (incidentIndication.id == null) {
        Utils.errorSnackBar(
            msg: "The Incident Indication Type field is required.",
            context: context);
        return false;
      }
      return true;
    } catch (e) {
      log("catchValidationSubmit--->${e.toString()}");
      return true;
    }
  }

  static Future<AddIncidentModel?> addIncidentData({
    required BuildContext context,
    required GetIncidentTypeData incidentType,
    required GetIncidentIndicationData incidentIndication,
    required String assetId,
    required String assetInternalId,
    required String address,
    required String landmark,
    required String currentLat,
    required String currentLong,
    required String markerLat,
    required String markerLong,
    required String description,
    required File photo,
  }) async {
    String userId = await SharedPref.getString(key: PrefsValue.userId);
    String schema = await SharedPref.getString(key: PrefsValue.schema);
    Map<String, String> body = {
      "schema": schema,
      "user_id": userId,
      "module_id": "",
      "incident_type_id": incidentType.id!.isEmpty ? "" : incidentType.id!.toString(),
      "incident_priority_id": "",
      "information_source_id": "",
      "indication_id": incidentIndication.id!.isEmpty ? "" : incidentIndication.id.toString(),
      "charge_area_id": "",
      "area_id": "",
      "location_source": "",
      "customer_id": "",
      "customer_type_data": "",
      "address": address.isEmpty ? "" : address.toString(),
      "landmark": landmark.isEmpty ? "" : landmark.toString(),
      "description": description.isEmpty ? "" : description.toString(),
      "latitude": currentLat.isEmpty ? "" : currentLat.toString(),
      "longitude": currentLong.isEmpty ? "" : currentLong.toString(),
      "instance_latitude": markerLat.isEmpty ? "" : markerLat.toString(),
      "instance_longitude": markerLong.isEmpty ? "" : markerLong.toString(),
      "remarks": "",
      "asset_type_id": assetId.isEmpty ? "" : assetId.toString(),
      "asset_internal_id": assetInternalId == "" ? "" : assetInternalId.toString(),
      "control_room_id": "",
      "security_guard_name": "",
      "security_guard_mobile": "",
      "security_guard_id": "",
      "info_customer_id": "",
      "info_customer_mobile": "",
      "info_customer_bpnumber": "",
      "other_name": "",
    };
    log("jsonBody-->${body}");
    try {
      var res = await ApiHelper.postDataWithFile(
        urlEndPoint: "${Apis.addIncident}",
        body: body,
        imageRequestObject: [
          ImageRequestObject(
              "attach_file", photo.path.isEmpty ? "" : photo.path.toString()),
        ],
        context: context,
      );
      if (res != null && res["error"] == false) {
        return AddIncidentModel.fromJson(res);
      } else if (res != null &&
          res['success'] != null &&
          res['success'] == 415 &&
          res['data'] != null) {
        Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      } else if (res != null && res["error"] == true) {
        Utils.errorSnackBar(msg: res["data"].toString(), context: context);
        return null;
      }
    } catch (e) {
      print("setNGCReportData-->${e.toString()}");
    }
    return null;
  }
}
