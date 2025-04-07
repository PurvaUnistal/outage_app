class GetControlRoomModel {
  int? success;
  bool? error;
  List<GetControlRoomData>? data;

  GetControlRoomModel({this.success, this.error, this.data});

  GetControlRoomModel.fromJson(Map<String, dynamic> json) {
    success = json['success' ] ?? "";
    error = json['error' ] ?? "";
    if (json['data'] != null) {
      data = <GetControlRoomData>[] ;
      json['data'].forEach((v) {
        data!.add(new GetControlRoomData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetControlRoomData {
  String? id;
  String? areaId;
  String? controlRoomName;
  dynamic shapeLeng;
  String? code;
  dynamic cityId;
  String? chargeAreaId;
  dynamic createdAt;

  GetControlRoomData(
      {this.id,
        this.areaId,
        this.controlRoomName,
        this.shapeLeng,
        this.code,
        this.cityId,
        this.chargeAreaId,
        this.createdAt});

  GetControlRoomData.fromJson(Map<String, dynamic> json) {
    id = json['id' ] ?? "";
    areaId = json['area_id' ] ?? "";
    controlRoomName = json['control_room_name' ] ?? "";
    shapeLeng = json['shape_leng' ] ?? "";
    code = json['code' ] ?? "";
    cityId = json['city_id' ] ?? "";
    chargeAreaId = json['charge_area_id' ] ?? "";
    createdAt = json['created_at' ] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_id'] = this.areaId;
    data['control_room_name'] = this.controlRoomName;
    data['shape_leng'] = this.shapeLeng;
    data['code'] = this.code;
    data['city_id'] = this.cityId;
    data['charge_area_id'] = this.chargeAreaId;
    data['created_at'] = this.createdAt;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return controlRoomName.toString();
  }
}
