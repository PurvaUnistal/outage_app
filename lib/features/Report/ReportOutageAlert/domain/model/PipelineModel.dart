import 'package:hive/hive.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';

part 'PipelineModel.g.dart';

class PipelineModel {
  int? success;
  bool? error;
  List<PipelineData>? data;

  PipelineModel({this.success, this.error, this.data});

  PipelineModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <PipelineData>[];
      json['data'].forEach((v) {
        data!.add(new PipelineData.fromJson(v));
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

@HiveType(typeId: HiveTypeId.pipelineData)
class PipelineData {
  @HiveField(0)
  String? geomencode;
  @HiveField(1)
  String? gid;
  @HiveField(2)
  String? districtI;
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
  @HiveField(8)
  String? imagePath;
  @HiveField(9)
  String? housePhoto;
  @HiveField(10)
  String? attachFile;
  @HiveField(11)
  String? bpName;

  PipelineData({
    this.geomencode,
    this.gid,
    this.districtI,
    this.nominaldia,
    this.contractor,
    this.name,
    this.location,
    this.district,
    this.imagePath,
    this.housePhoto,
    this.attachFile,
    this.bpName,
  });

  PipelineData.fromJson(Map<String, dynamic> json) {
    geomencode = json['geomencode'] ?? "";
    gid = json['gid'] ?? "";
    districtI = json['district_i'] ?? "";
    nominaldia = json['nominaldia'] ?? "";
    contractor = json['contractor'];
    name = json['name'] ?? "";
    location = json['location'] ?? "";
    district = json['district'];
    imagePath = json['imagepath'] ?? "";
    housePhoto = json['house_photo'] ?? "";
    attachFile = json['attach_file'] ?? "";
    bpName = json['bp_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geomencode'] = this.geomencode;
    data['gid'] = this.gid;
    data['district_i'] = this.districtI;
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
}
