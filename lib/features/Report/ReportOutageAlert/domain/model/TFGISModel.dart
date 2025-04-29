import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'TFGISModel.g.dart';

class TFGISModel {
  int? success;
  bool? error;
  String? assetId;
  List<TFGISData>? data;

  TFGISModel({this.success, this.error, this.assetId, this.data});

  TFGISModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    error = json['error'] ?? "";
    assetId = json['assetid'] ?? "";
    if (json['data'] != null) {
      data = <TFGISData>[];
      json['data'].forEach((v) {
        data!.add(new TFGISData.fromJson(v));
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

@HiveType(typeId: HiveTypeId.tfGis)
class TFGISData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? latitude;
  @HiveField(2)
  String? longitude;
  @HiveField(3)
  String? tfNumber;

  TFGISData({this.id, this.latitude, this.longitude, this.tfNumber});

  TFGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    tfNumber = json['tf_number'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['tf_number'] = this.tfNumber;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
