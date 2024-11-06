// To parse this JSON data, do
//
//     final getTfgisModel = getTfgisModelFromJson(jsonString);

import 'dart:convert';

GetTfGisModel getTfGisModelFromJson(String str) => GetTfGisModel.fromJson(json.decode(str));

String getTfGisModelToJson(GetTfGisModel data) => json.encode(data.toJson());

class GetTfGisModel {
  int? success;
  bool? error;
  List<TfGisData>? data;

  GetTfGisModel({
    this.success,
    this.error,
    this.data,
  });

  factory GetTfGisModel.fromJson(Map<String, dynamic> json) => GetTfGisModel(
    success: json["success"] ?? "",
    error: json["error"] ?? "",
    data: json["data"] == null ? null : List<TfGisData>.from(json["data"].map((x) => TfGisData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TfGisData {
  String? id;
  String? latitude;
  String? longitude;

  TfGisData({
    this.id,
    this.latitude,
    this.longitude,
  });

  factory TfGisData.fromJson(Map<String, dynamic> json) => TfGisData(
    id: json["id"] ?? "",
    latitude: json["latitude"] ?? "",
    longitude: json["longitude"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
  };
  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
