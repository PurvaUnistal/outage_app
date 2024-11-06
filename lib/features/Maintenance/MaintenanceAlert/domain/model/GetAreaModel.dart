import 'dart:convert';

List<GetAreaModel> getAreaListModelFromJson(String str) =>
    List<GetAreaModel>.from(json.decode(str).map((x) => GetAreaModel.fromJson(x)));

String getAreaListModelToJson(List<GetAreaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAreaModel {
  String? gid;
  dynamic objectid;
  String? areaName;
  dynamic shapeLeng;
  String? areacode;
  dynamic cityId;
  String? chargeAreaId;
  dynamic subareacod;
  dynamic shapeLe1;
  dynamic shapeArea;
  String? readyForConnection;

  GetAreaModel(
      {this.gid,
        this.objectid,
        this.areaName,
        this.shapeLeng,
        this.areacode,
        this.cityId,
        this.chargeAreaId,
        this.subareacod,
        this.shapeLe1,
        this.shapeArea,
        this.readyForConnection});

  GetAreaModel.fromJson(Map<String, dynamic> json) {
    gid = json['gid'] ?? "";
    objectid = json['objectid'] ?? "";
    areaName = json['area_name'] ?? "";
    shapeLeng = json['shape_leng'] ?? "";
    areacode = json['areacode'] ?? "";
    cityId = json['city_id'] ?? "";
    chargeAreaId = json['charge_area_id'] ?? "";
    subareacod = json['subareacod'] ?? "";
    shapeLe1 = json['shape_le_1'] ?? "";
    shapeArea = json['shape_area'] ?? "";
    readyForConnection = json['ready_for_connection'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['objectid'] = this.objectid;
    data['area_name'] = this.areaName;
    data['shape_leng'] = this.shapeLeng;
    data['areacode'] = this.areacode;
    data['city_id'] = this.cityId;
    data['charge_area_id'] = this.chargeAreaId;
    data['subareacod'] = this.subareacod;
    data['shape_le_1'] = this.shapeLe1;
    data['shape_area'] = this.shapeArea;
    data['ready_for_connection'] = this.readyForConnection;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return areaName.toString();
  }
}
