// To parse this JSON data, do
//
//     final incidentActionProgressModel = incidentActionProgressModelFromJson(jsonString);

import 'dart:convert';

IncidentActionProgressModel incidentActionProgressModelFromJson(String str) => IncidentActionProgressModel.fromJson(json.decode(str));

String incidentActionProgressModelToJson(IncidentActionProgressModel data) => json.encode(data.toJson());

class IncidentActionProgressModel {
  int? success;
  bool? error;
  Data? data;

  IncidentActionProgressModel({
    this.success,
    this.error,
    this.data,
  });

  factory IncidentActionProgressModel.fromJson(Map<String, dynamic> json) => IncidentActionProgressModel(
    success: json["success"],
    error: json["error"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "data": data!.toJson(),
  };
}

class Data {
  String? response;
  String? finalStatus;

  Data({
    this.response,
    this.finalStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    response: json["response"],
    finalStatus: json["final_status"],
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "final_status": finalStatus,
  };
}
