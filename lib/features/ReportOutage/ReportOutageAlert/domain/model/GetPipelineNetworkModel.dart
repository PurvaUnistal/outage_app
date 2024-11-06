// To parse this JSON data, do
//
//     final getPipelineNetworkModel = getPipelineNetworkModelFromJson(jsonString);

import 'dart:convert';

GetPipelineNetworkModel getPipelineNetworkModelFromJson(String str) => GetPipelineNetworkModel.fromJson(json.decode(str));

String getPipelineNetworkModelToJson(GetPipelineNetworkModel data) => json.encode(data.toJson());

class GetPipelineNetworkModel {
  int? success;
  bool? error;
  List<PipelineNetworkData>? data;

  GetPipelineNetworkModel({
    this.success,
    this.error,
    this.data,
  });

  factory GetPipelineNetworkModel.fromJson(Map<String, dynamic> json) => GetPipelineNetworkModel(
    success: json["success"] ?? "",
    error: json["error"] ?? "",
    data: json["data"] == null ? null : List<PipelineNetworkData>.from(json["data"].map((x) => PipelineNetworkData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PipelineNetworkData {
  String? nominaldia;
  String? geomencode;

  PipelineNetworkData({
    this.nominaldia,
    this.geomencode,
  });

  factory PipelineNetworkData.fromJson(Map<String, dynamic> json) => PipelineNetworkData(
    nominaldia: json["nominaldia"] ?? "",
    geomencode: json["geomencode"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "nominaldia": nominaldia,
    "geomencode": geomencode,
  };
}
