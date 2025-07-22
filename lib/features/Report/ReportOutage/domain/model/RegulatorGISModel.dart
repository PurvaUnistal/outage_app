import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';

part 'RegulatorGISModel.g.dart';

class RegulatorGISModel {
  int? success;
  bool? error;
  String? assetId;
  dynamic data;

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
  @HiveField(3)
  String? nominaldia;
  @HiveField(4)
  String? contractor;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String? location;
  @HiveField(7)
  String? district;
  @HiveField(9)
  String? imagePath;
  @HiveField(10)
  String? housePhoto;
  @HiveField(11)
  String? attachFile;
  @HiveField(12)
  String? bpName;
  @HiveField(13)
  String? assetid = "10";
  @HiveField(14)
  String? regulatorid;

  RegulatorGISData({
    this.id,
    this.latitude,
    this.longitude,
    this.nominaldia,
    this.contractor,
    this.name,
    this.location,
    this.district,
    this.imagePath,
    this.housePhoto,
    this.attachFile,
    this.bpName,
    this.assetid,
    this.regulatorid,
  });

  RegulatorGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    nominaldia = json['nominaldia'] ?? "";
    contractor = json['contractor'];
    name = json['name'] ?? "";
    location = json['location'] ?? "";
    district = json['district'] ?? "";
    imagePath = json['imagepath'] ?? "";
    housePhoto = json['house_photo'] ?? "";
    attachFile = json['attach_file'] ?? "";
    bpName = json['bp_name'] ?? "";
    regulatorid = json['regulatorid'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['nominaldia'] = this.nominaldia;
    data['contractor'] = this.contractor;
    data['name'] = this.name;
    data['location'] = this.location;
    data['district'] = this.district;
    data['imagepath'] = this.imagePath;
    data['house_photo'] = this.housePhoto;
    data['attach_file'] = this.attachFile;
    data['bp_name'] = this.bpName;
    data['regulatorid'] = this.regulatorid;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return regulatorid.toString();
  }
}
