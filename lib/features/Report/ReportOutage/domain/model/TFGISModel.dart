import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';

part 'TFGISModel.g.dart';

class TFGISModel {
  int? success;
  bool? error;
  String? assetId;
  dynamic data;

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
  @HiveField(4)
  String? nominaldia;
  @HiveField(5)
  String? contractor;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? location;
  @HiveField(8)
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
  String? assetid = "7";

  TFGISData({
    this.id,
    this.latitude,
    this.longitude,
    this.tfNumber,
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
  });

  TFGISData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    tfNumber = json['tf_number'] ?? "";
    nominaldia = json['nominaldia'] ?? "";
    contractor = json['contractor'];
    name = json['name'] ?? "";
    location = json['location'] ?? "";
    district = json['district'] ?? "";
    imagePath = json['imagepath'] ?? "";
    housePhoto = json['house_photo'] ?? "";
    attachFile = json['attach_file'] ?? "";
    bpName = json['bp_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['tf_number'] = this.tfNumber;
    data['nominaldia'] = this.nominaldia;
    data['contractor'] = this.contractor;
    data['name'] = this.name;
    data['location'] = this.location;
    data['district'] = this.district;
    data['imagepath'] = this.imagePath;
    data['house_photo'] = this.housePhoto;
    data['attach_file'] = this.attachFile;
    data['bp_name'] = this.bpName;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}
