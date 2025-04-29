import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'ConsumerGISModel.g.dart';

class ConsumerGISModel {
  int? success;
  bool? error;
  String? assetId;
  List<ConsumerGISData>? data;

  ConsumerGISModel({this.success, this.error, this.assetId, this.data});

  ConsumerGISModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    assetId = json['assetid'];
    if (json['data'] != null) {
      data = <ConsumerGISData>[];
      json['data'].forEach((v) {
        data!.add(new ConsumerGISData.fromJson(v));
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


@HiveType(typeId: HiveTypeId.consumerGis)
class ConsumerGISData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? bpName;
  @HiveField(2)
  String? bpNumber;
  @HiveField(3)
  String? legacyNo;
  @HiveField(4)
  String? latitude;
  @HiveField(5)
  String? longitude;

  ConsumerGISData(
      {this.id,
        this.bpName,
        this.bpNumber,
        this.legacyNo,
        this.latitude,
        this.longitude});

  ConsumerGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bpName = json['bp_name'];
    bpNumber = json['bp_number'];
    legacyNo = json['legacy_no'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bp_name'] = this.bpName;
    data['bp_number'] = this.bpNumber;
    data['legacy_no'] = this.legacyNo;
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
