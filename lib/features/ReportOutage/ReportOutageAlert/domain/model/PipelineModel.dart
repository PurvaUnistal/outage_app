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

class PipelineData {
  String? gid;
  String? nominaldia;
  String? geomencode;

  PipelineData({this.gid, this.nominaldia, this.geomencode});

  PipelineData.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    nominaldia = json['nominaldia'];
    geomencode = json['geomencode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['nominaldia'] = this.nominaldia;
    data['geomencode'] = this.geomencode;
    return data;
  }
}
