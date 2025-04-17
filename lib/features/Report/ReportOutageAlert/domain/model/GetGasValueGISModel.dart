class GetGasValueGISModel {
  int? success;
  bool? error;
  List<GetGasValueGISData>? data;

  GetGasValueGISModel({this.success, this.error, this.data});

  GetGasValueGISModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <GetGasValueGISData>[];
      json['data'].forEach((v) {
        data!.add(new GetGasValueGISData.fromJson(v));
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

class GetGasValueGISData {
  String? geomtext;
  String? geomBinary;
  String? latitude;
  String? longitude;

  GetGasValueGISData({this.geomtext, this.geomBinary, this.latitude, this.longitude});

  GetGasValueGISData.fromJson(Map<String, dynamic> json) {
    geomtext = json['geomtext'];
    geomBinary = json['geomBinary'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geomtext'] = this.geomtext;
    data['geomBinary'] = this.geomBinary;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
