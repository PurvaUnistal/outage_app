import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'ValveGISModel.g.dart';

class ValveGISModel {
  int? success;
  bool? error;
  String? assetId;
  List<ValveGISData>? data;

  ValveGISModel({this.success, this.error, this.assetId, this.data});

  ValveGISModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    assetId = json['assetid'];
    if (json['data'] != null) {
      data = <ValveGISData>[];
      json['data'].forEach((v) {
        data!.add(new ValveGISData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['assetid'] = this.assetId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


@HiveType(typeId: HiveTypeId.valveGis)
class ValveGISData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? longitude;
  @HiveField(2)
  String? latitude;
  @HiveField(3)
  String? valveId;
  @HiveField(4)
  String? gridId;

  ValveGISData({this.id, this.longitude, this.latitude, this.valveId, this.gridId});

  ValveGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    valveId = json['valve_id'];
    gridId = json['grid_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['valve_id'] = this.valveId;
    data['grid_id'] = this.gridId;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return valveId.toString();
  }
}
