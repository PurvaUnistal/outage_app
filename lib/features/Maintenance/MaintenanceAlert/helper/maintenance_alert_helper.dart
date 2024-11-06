import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/model/GetLocationSourceModel.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/model/GetPriorityTypeModel.dart';
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

class MaintenanceAlertHelper{

  static Future<GetModuleTypeModel?> getOutageModuleApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getOutageModule +json, context: context);
      GetModuleTypeModel response = GetModuleTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getOutageModule-->${e.toString()}");
    }
    return null;
  }

  static Future<GetIncidentTypeModel?> getIncidentTypeApi({required BuildContext context, required String moduleId}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
      "module_id": moduleId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentType +json, context: context);
      GetIncidentTypeModel response = GetIncidentTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentType-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPriorityTypeModel?> getIncidentPriorityApi({required BuildContext context, required String moduleId}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
      "module_id": moduleId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentPriority +json, context: context);
      GetPriorityTypeModel response = GetPriorityTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentPriority-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetLocationSourceModel>?> getLocationSourceApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getLocationSource, context: context);
      return GetLocationSourceModel.mapToList(res["data"]);
    } catch (e) {
      log("getLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPriorityTypeModel?> getInformationSourceApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getInformationSource +json, context: context);
      GetPriorityTypeModel response = GetPriorityTypeModel.fromJson(res);
      return response;
    } catch (e) {
      log("getInformationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetIncidentIndicationModel?> getIncidentIndicationApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getIncidentIndication +json, context: context);
      GetIncidentIndicationModel response = GetIncidentIndicationModel.fromJson(res);
      return response;
    } catch (e) {
      log("getIncidentIndication-->${e.toString()}");
    }
    return null;
  }

  static Future<ViewIncidentModel?> getViewIncidentApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getViewIncident +json, context: context);
      ViewIncidentModel response = ViewIncidentModel.fromJson(res);
      return response;
    } catch (e) {
      log("getViewIncident-->${e.toString()}");
    }
    return null;
  }

  static Future<List<GetLocationSourceModel>?>getCustomerLocationSourceApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getCustomerLocationSource, context: context);
      return GetLocationSourceModel.mapToList(res["data"]);
    } catch (e) {
      log("getCustomerLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetAssetModel?> getAssetLocationSourceApi({required BuildContext context}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getAssetLocationSource +json, context: context);
      GetAssetModel response = GetAssetModel.fromJson(res);
      return response;
    } catch (e) {
      log("getAssetLocationSource-->${e.toString()}");
    }
    return null;
  }

  static Future<GetCustomerLocationModel?> getCustomerDetailByLocationApi({
    required BuildContext context, required String locationSource, required String search}) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
      "location_source": locationSource,
      "serach": search,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getCustomerDetailByLocation +json, context: context);
      GetCustomerLocationModel response = GetCustomerLocationModel.fromJson(res);
      return response;
    } catch (e) {
      log("getCustomerDetailByLocation-->${e.toString()}");
    }
    return null;
  }

  static Future<GetControlRoomModel?> getControlRoomApi({
    required BuildContext context, required String areaId, }) async {
    String schema = await SharedPref.getString(key: PrefsValue.schema,);
    Map<String, String> para = {
      "schema": schema,
      "area_id": areaId,
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getControlRoom +json, context: context);
      GetControlRoomModel response = GetControlRoomModel.fromJson(res);
      return response;
    } catch (e) {
      log("getControlRoom-->${e.toString()}");
    }
    return null;
  }

  static Future<dynamic> validationSubmit({
    required BuildContext context,
    required GetModuleTypeData moduleType,
    required GetIncidentTypeData incidentType,
    required GetPriorityTypeData incidentPriority,
    required GetLocationSourceModel locationSource,
    required GetLocationSourceModel customerType,
    required String customerSearchNumber,
    required GetAssetData customerAsset,
    required TfGisData assetInternalId,
    required String customerLocation,
    required GetPriorityTypeData infoSource,
    required String infoSecurityName,
    required String infoSecurityId,
    required String infoSecurityMobile,
    required String infoCustName,
    required String infoCustBpNumber,
    required String infoCustMobile,
    required String infoOtherName,
    required String address,
    required String landmark,
    required GetIncidentIndicationData incidentIndication,
    required GetChargeAreaModel chargeArea,
    required GetAreaModel area,
    required GetControlRoomData controlRoom,
    required File photo,
  }) async {
    try{
      if(moduleType.moduleAlias == null){
        Utils.errorSnackBar(msg: "The Module Type field is required.", context: context);
        return false;
      } else if(incidentType.id == null){
        Utils.errorSnackBar(msg: "The Incident Type field is required.", context: context);
        return false;
      } else if(incidentPriority.id == null){
        Utils.errorSnackBar(msg: "The Incident Priority field is required.", context: context);
        return false;
      } else if(locationSource.key == null){
        Utils.errorSnackBar(msg: "The Location Source field is required.", context: context);
        return false;
      } else if(locationSource.key == "1"){
        if(customerType.key == null){
          Utils.errorSnackBar(msg: "The Customer Type field is required.", context: context);
          return false;
        } else if(customerSearchNumber.isEmpty){
          if(customerType.key == "1"){
            Utils.errorSnackBar(msg: "The BP Number field is required.", context: context);
            return false;
          } else if(customerType.key == "2"){
            Utils.errorSnackBar(msg: "The Mobile Number field is required.", context: context);
            return false;
          } else if(customerType.key == "3"){
            Utils.errorSnackBar(msg: "The Meter Number field is required.", context: context);
            return false;
          }
        }
      } else if(locationSource.key == "2"){
        if(customerAsset.id == null){
          Utils.errorSnackBar(msg: "The Asset Id is required.", context: context);
          return false;
        }else if(assetInternalId.id == null){
          Utils.errorSnackBar(msg: "The Asset Type Id is required.", context: context);
          return false;
        }
      } else if(locationSource.key == "3"){
        if(customerLocation.isEmpty){
          Utils.errorSnackBar(msg: "The Location field is required.", context: context);
          return false;
        }
      }
      if(infoSource.id == null){
        Utils.errorSnackBar(msg: "The Information Source field is required.", context: context);
        return false;
      } else if(infoSource.id == "1"){
        if(infoSecurityName.isEmpty){
          Utils.errorSnackBar(msg: "The Security Guard Name field is required.", context: context);
          return false;
        } else if(infoSecurityId.isEmpty){
          Utils.errorSnackBar(msg: "The Security Guard Id field is required.", context: context);
          return false;
        }else if(infoSecurityMobile.isEmpty){
          Utils.errorSnackBar(msg: "The Security Guard Mobile field is required.", context: context);
          return false;
        }
      } else if(infoSource.id == "2"){
        if(infoCustName.isEmpty){
          Utils.errorSnackBar(msg: "The Customer Name field is required.", context: context);
          return false;
        } else if(infoCustBpNumber.isEmpty){
          Utils.errorSnackBar(msg: "The Customer BP Number field is required.", context: context);
          return false;
        } else if(infoCustMobile.isEmpty){
          Utils.errorSnackBar(msg: "The Customer Mobile field is required.", context: context);
          return false;
        }
      } else if(infoSource.id == "4"){
        if(infoOtherName.isEmpty){
          Utils.errorSnackBar(msg: "The Other Name field is required.", context: context);
          return false;
        }
      }
      if(address.isEmpty){
        Utils.errorSnackBar(msg: "The Address field is required.", context: context);
        return false;
      } else if(landmark.isEmpty){
        Utils.errorSnackBar(msg: "The Landmark field is required.", context: context);
        return false;
      } else if(incidentIndication.id == null){
        Utils.errorSnackBar(msg: "The Incident Indication Type field is required.", context: context);
        return false;
      } else if(chargeArea.gid == null){
        Utils.errorSnackBar(msg: "The Charge Area Type field is required.", context: context);
        return false;
      } else if(area.gid == null){
        Utils.errorSnackBar(msg: "The Area Type field is required.", context: context);
        return false;
      } else if(controlRoom.id == null){
        Utils.errorSnackBar(msg: "The Control Room Type field is required.", context: context);
        return false;
      }
      return true;
    } catch(e){
      log("catchValidationSubmit--->${e.toString()}");
      return true;
    }
  }


  static Future<AddIncidentModel?> addIncidentData({
    required BuildContext context,
    required GetModuleTypeData moduleType,
    required GetIncidentTypeData incidentType,
    required GetPriorityTypeData incidentPriority,
    required GetLocationSourceModel locationSource,
    required GetLocationSourceModel customerType,
    required String customerSearchNumber,
    required GetAssetData customerAsset,
    required TfGisData assetInternalId,
    required String customerLocation,
    required GetPriorityTypeData infoSource,
    required String infoSecurityName,
    required String infoSecurityId,
    required String infoSecurityMobile,
    required String infoCustName,
    required String infoCustBpNumber,
    required String infoCustMobile,
    required String infoOtherName,
    required String address,
    required String landmark,
    required String latitude,
    required String longitude,
    required GetIncidentIndicationData incidentIndication,
    required GetChargeAreaModel chargeArea,
    required GetAreaModel area,
    required GetControlRoomData controlRoom,
    required String description,
    required String remarks,
    required File photo,
  }) async {
    String userId = await SharedPref.getString(key: PrefsValue.userId);
    String schema = await SharedPref.getString(key: PrefsValue.schema);
    Map<String, String> body = {
      "schema": schema,
      "user_id": userId,
      "module_id": moduleType.id!.isEmpty ? "" : moduleType.id!.toString(),
      "incident_type_id": incidentType.id!.isEmpty ? "" :incidentType.id!.toString(),
      "incident_priority_id": incidentPriority.id!.isEmpty ? "" :incidentPriority.id!,
      "information_source_id": infoSource.id!.isEmpty ? "" : infoSource.id!.toString(),
      "indication_id": locationSource.key!.isEmpty ? "" :locationSource.key!.toString(),
      "charge_area_id": chargeArea.gid!.isEmpty ? "" :chargeArea.gid!.toString(),
      "area_id": area.gid!.isEmpty ? "" : area.gid!.toString(),
      "location_source": locationSource.key!.isEmpty  ? "" :locationSource.key!.toString(),
      "customer_id": customerLocation.isEmpty ? "" : customerLocation.toString(),
      "customer_type_data": customerSearchNumber.isEmpty ? "" : customerSearchNumber.toString(),
      "address": address.isEmpty ? "" : address.toString(),
      "landmark": landmark.isEmpty ? "" :landmark.toString(),
      "description": description.isEmpty ? "" : description.toString(),
      "latitude": latitude.isEmpty ? "" : latitude.toString(),
      "longitude": longitude.isEmpty ? "" : longitude.toString(),
      "remarks": remarks.isEmpty ? "" : remarks.toString(),
      "asset_type_id": customerAsset.id == null ? "": customerAsset.id!.toString(),
      "asset_internal_id": assetInternalId.id == null ? "": customerAsset.id!.toString(),
      "control_room_id": controlRoom.id == null ? "": controlRoom.id!.toString(),
      "security_guard_name": infoSecurityName.isEmpty  ? "" : infoSecurityName.toString(),
      "security_guard_mobile": infoSecurityMobile.isEmpty ? "": infoSecurityMobile.toString(),
      "security_guard_id": infoSecurityId.isEmpty ? "" : infoSecurityId.toString(),
      "info_customer_id": infoCustName.isEmpty ? "" :infoCustName.toString(),
      "info_customer_mobile": infoCustMobile.isEmpty ? "" :infoCustMobile.toString(),
      "info_customer_bpnumber": infoCustBpNumber.isEmpty ? "" :infoCustBpNumber.toString(),
      "other_name": infoOtherName.isEmpty ? "" :infoOtherName.toString(),
    };
    log("jsonBody-->${body}");
    try {
      var res = await ApiHelper.postDataWithFile(
        urlEndPoint: "${Apis.addIncident}",
        body: body,
        imageRequestObject: [
          ImageRequestObject("attach_file", photo.path.isEmpty ? "" : photo.path.toString()),
        ],
        context: context,
      );
      if (res != null && res["error"] == false) {
        return AddIncidentModel.fromJson(res);
      } else if (res != null && res['success'] != null && res['success'] == 415 && res['data'] != null) {
        Utils.errorSnackBar(msg: res["data"].toString(),context: context);
        return null;
      } else if ( res != null && res["error"] == true){
        Utils.errorSnackBar(msg: res["data"].toString(),context: context);
        return null;
      }
    }catch(e){
      print("setNGCReportData-->${e.toString()}");
    }
    return null;
  }

}