import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
part 'IndustrialModel.g.dart';
class IndustrialModel {
  int? success;
  bool? error;
  dynamic data;

  IndustrialModel({this.success, this.error,  this.data});

  IndustrialModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    error = json['error'] ?? "";
    if (json['data'] != null) {
      data = <IndustrialData>[];
      json['data'].forEach((v) {
        data!.add(new IndustrialData.fromJson(v));
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

@HiveType(typeId: HiveTypeId.industrial)
class IndustrialData {
  @HiveField(0)
  String? imagePath;
  @HiveField(1)
  String? attachFile;
  @HiveField(2)
  String? housePhoto;
  @HiveField(3)
  String? id;
  @HiveField(4)
  String? bpName;
  @HiveField(5)
  String? bpNumber;
  @HiveField(6)
  String? legacyNo;
  @HiveField(7)
  String? latitude;
  @HiveField(8)
  String? longitude;
  @HiveField(9)
  String? nominaldia;
  @HiveField(10)
  String? contractor;
  @HiveField(11)
  String? name;
  @HiveField(12)
  String? location;
  @HiveField(13)
  String? district;
  @HiveField(14)
  String? assetid = "0";

  IndustrialData(
      {this.imagePath,
        this.housePhoto,
        this.attachFile,
        this.id,
        this.bpName,
        this.bpNumber,
        this.legacyNo,
        this.latitude,
        this.longitude,
        this.nominaldia,
        this.contractor,
        this.name,
        this.location,
        this.district,
        this.assetid,
      });

  IndustrialData.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagepath'] ?? "";
    housePhoto = json['house_photo'] ?? "";
    attachFile = json['attach_file'] ?? "";
    id = json['id'] ?? "";
    bpName = json['bp_name'] ?? "";
    bpNumber = json['bp_number'] ?? "";
    legacyNo = json['legacy_no'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    nominaldia = json['nominaldia'] ?? "";
    contractor = json['contractor'];
    name = json['name'] ?? "";
    location = json['location'] ?? "";
    district = json['district'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagepath'] = this.imagePath;
    data['house_photo'] = this.housePhoto;
    data['attach_file'] = this.attachFile;
    data['id'] = this.id;
    data['bp_name'] = this.bpName;
    data['bp_number'] = this.bpNumber;
    data['legacy_no'] = this.legacyNo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['nominaldia'] = this.nominaldia;
    data['contractor'] = this.contractor;
    data['name'] = this.name;
    data['location'] = this.location;
    data['district'] = this.district;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
