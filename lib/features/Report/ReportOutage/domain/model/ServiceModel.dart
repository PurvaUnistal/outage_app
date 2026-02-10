import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'ServiceModel.g.dart';

class ServiceModel {
  int? success;
  bool? error;
  String? assetid;
  List<ServiceData>? data;

  ServiceModel({this.success, this.error, this.assetid, this.data});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    assetid = json['assetid'];
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add(new ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['assetid'] = this.assetid;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: HiveTypeId.serviceGIS)
class ServiceData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? servicePointId;
  @HiveField(2)
  String? latitude;
  @HiveField(3)
  String? longitude;
  @HiveField(4)
  String? location;
  @HiveField(5)
  String? district;
  @HiveField(6)
  String? nominaldia;

  ServiceData(
      {this.id,
        this.servicePointId,
        this.latitude,
        this.longitude,
        this.location,
        this.district,
        this.nominaldia});

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicePointId = json['servicepointid'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    district = json['district'];
    nominaldia = json['nominaldia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['servicepointid'] = this.servicePointId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    data['district'] = this.district;
    data['nominaldia'] = this.nominaldia;
    return data;
  }
}
