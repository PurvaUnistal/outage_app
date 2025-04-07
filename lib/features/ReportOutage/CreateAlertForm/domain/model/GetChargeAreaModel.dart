import 'dart:convert';

List<GetChargeAreaModel> getChargeAreaListModelFromJson(String str) =>
    List<GetChargeAreaModel>.from(json.decode(str).map((x) => GetChargeAreaModel.fromJson(x)));


String getChargeAreaListModelToJson(List<GetChargeAreaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChargeAreaModel {
  String? gid;
  String? chargeAreaCode;
  dynamic projectId;
  dynamic objectid;
  dynamic shapeLeng;
  dynamic shapeArea;
  String? chargeAreaName;

  GetChargeAreaModel(
      {this.gid,
        this.chargeAreaCode,
        this.projectId,
        this.objectid,
        this.shapeLeng,
        this.shapeArea,
        this.chargeAreaName});

  GetChargeAreaModel.fromJson(Map<String, dynamic> json) {
    gid = json['gid'] ?? "";
    chargeAreaCode = json['charge_area_code'] ?? "";
    projectId = json['project_id'] ?? "";
    objectid = json['objectid'] ?? "";
    shapeLeng = json['shape_leng'] ?? "";
    shapeArea = json['shape_area'] ?? "";
    chargeAreaName = json['charge_area_name'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['charge_area_code'] = this.chargeAreaCode;
    data['project_id'] = this.projectId;
    data['objectid'] = this.objectid;
    data['shape_leng'] = this.shapeLeng;
    data['shape_area'] = this.shapeArea;
    data['charge_area_name'] = this.chargeAreaName;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return chargeAreaName.toString();
  }
}
