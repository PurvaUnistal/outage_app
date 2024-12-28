// To parse this JSON data, do
//
//     final getTfgisModel = getTfgisModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:igl_outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';


GetGasGisModel getTfGisModelFromJson(String str) => GetGasGisModel.fromJson(json.decode(str));

String getTfGisModelToJson(GetGasGisModel data) => json.encode(data.toJson());

class GetGasGisModel {
  int? success;
  bool? error;
  String? assetId;
  List<GasGisData>? data;

  GetGasGisModel({
    this.success,
    this.error,
    this.assetId,
    this.data,
  });

  factory GetGasGisModel.fromJson(Map<String, dynamic> json) => GetGasGisModel(
    success: json["success"] ?? "",
    error: json["error"] ?? "",
    assetId: json["assetid"] ?? "",
    data: json["data"] == null ? null : List<GasGisData>.from(json["data"].map((x) => GasGisData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "assetid": assetId,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GasGisData {
  String? id;
  String? latitude;
  String? longitude;
  String? valveId;

  GasGisData({
    this.id,
    this.latitude,
    this.longitude,
    this.valveId,
  });

  factory GasGisData.fromJson(Map<String, dynamic> json) => GasGisData(
    id: json["id"] ?? "",
    latitude: json["latitude"] ?? "",
    longitude: json["longitude"] ?? "",
    valveId: json["valve_id"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "valve_id": valveId,
  };
  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
