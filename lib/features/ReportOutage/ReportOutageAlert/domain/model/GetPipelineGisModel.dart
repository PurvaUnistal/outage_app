class GetPipelineGisModel {
  int? success;
  bool? error;
  List<GetPipelineGisData>? data;

  GetPipelineGisModel({this.success, this.error, this.data});

  GetPipelineGisModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <GetPipelineGisData>[];
      json['data'].forEach((v) {
        data!.add(new GetPipelineGisData.fromJson(v));
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

class GetPipelineGisData {
  String? geomencode;
  String? geomtext;
  String? geomBinary;

  GetPipelineGisData({this.geomencode, this.geomtext, this.geomBinary});

  GetPipelineGisData.fromJson(Map<String, dynamic> json) {
    geomencode = json['geomencode'];
    geomtext = json['geomtext'];
    geomBinary = json['geomBinary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geomencode'] = this.geomencode;
    data['geomtext'] = this.geomtext;
    data['geomBinary'] = this.geomBinary;
    return data;
  }
}
