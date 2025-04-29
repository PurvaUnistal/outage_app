import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'RegulatorGISModel.g.dart';

class RegulatorGISModel {
  int? success;
  bool? error;
  String? assetId;
  List<RegulatorGISData>? data;

  RegulatorGISModel({this.success, this.error, this.assetId, this.data});

  RegulatorGISModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    assetId = json['assetid'];
    if (json['data'] != null) {
      data = <RegulatorGISData>[];
      json['data'].forEach((v) {
        data!.add(new RegulatorGISData.fromJson(v));
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

@HiveType(typeId: HiveTypeId.regulatorGis)
class RegulatorGISData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? latitude;
  @HiveField(2)
  String? longitude;

  RegulatorGISData({this.id, this.latitude, this.longitude});

  RegulatorGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
