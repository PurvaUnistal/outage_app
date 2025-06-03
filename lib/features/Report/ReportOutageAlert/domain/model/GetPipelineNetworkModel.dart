// To parse this JSON data, do
//
//     final getPipelineNetworkModel = getPipelineNetworkModelFromJson(jsonString);

import 'dart:convert';

GetPipelineNetworkModel getPipelineNetworkModelFromJson(String str) =>
    GetPipelineNetworkModel.fromJson(json.decode(str));

String getPipelineNetworkModelToJson(GetPipelineNetworkModel data) =>
    json.encode(data.toJson());

class GetPipelineNetworkModel {
  int? success;
  bool? error;
  dynamic data;

  GetPipelineNetworkModel({this.success, this.error, this.data});

  factory GetPipelineNetworkModel.fromJson(Map<String, dynamic> json) =>
      GetPipelineNetworkModel(
        success: json["success"] ?? "",
        error: json["error"] ?? "",
        data:
            json['data'] is String
                ? json['data']
                : List<PipelineNetworkData>.from(
                  json["data"].map((x) => PipelineNetworkData.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PipelineNetworkData {
  String? geomencode;
  String? gid;
  String? districtI;
  String? nominaldia;
  String? contractor;
  String? name;
  String? city;
  String? district;
  String? imagePath;
  String? housePhoto;
  String? attachFile;

  PipelineNetworkData({
    this.geomencode,
    this.gid,
    this.districtI,
    this.nominaldia,
    this.contractor,
    this.name,
    this.city,
    this.district,
    this.imagePath,
    this.housePhoto,
    this.attachFile,
  });

  PipelineNetworkData.fromJson(Map<String, dynamic> json) {
    geomencode = json['geomencode'] ?? "";
    gid = json['gid'] ?? "";
    districtI = json['district_i'] ?? "";
    nominaldia = json['nominaldia'] ?? "";
    contractor = json['contractor'];
    name = json['name'] ?? "";
    city = json['city'] ?? "";
    district = json['district'] ?? "";
    imagePath = json['imagepath'] ?? "";
    housePhoto = json['house_photo'] ?? "";
    attachFile = json['attach_file'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geomencode'] = this.geomencode;
    data['gid'] = this.gid;
    data['district_i'] = this.districtI;
    data['nominaldia'] = this.nominaldia;
    data['contractor'] = this.contractor;
    data['name'] = this.name;
    data['city'] = this.city;
    data['district'] = this.district;
    data['imagepath'] = this.imagePath;
    data['house_photo'] = this.housePhoto;
    data['attach_file'] = this.attachFile;
    return data;
  }
}
