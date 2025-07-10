class DistrictDataModel {
  int? success;
  bool? error;
  Dashboard? dashboard;
  List<DistrictData>? data;

  DistrictDataModel({this.success, this.error, this.dashboard, this.data});

  DistrictDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    dashboard = json['dashboard'] != null
        ? new Dashboard.fromJson(json['dashboard'])
        : null;
    if (json['data'] != null) {
      data = <DistrictData>[];
      json['data'].forEach((v) {
        data!.add(new DistrictData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dashboard {
  String? mdpeLength;
  String? steelLength;
  int? domesticCount;
  int? industrialCommercialCount;

  Dashboard(
      {this.mdpeLength,
        this.steelLength,
        this.domesticCount,
        this.industrialCommercialCount});

  Dashboard.fromJson(Map<String, dynamic> json) {
    mdpeLength = json['mdpe_length'];
    steelLength = json['steel_length'];
    domesticCount = json['domestic_count'];
    industrialCommercialCount = json['industrial_commercial_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mdpe_length'] = this.mdpeLength;
    data['steel_length'] = this.steelLength;
    data['domestic_count'] = this.domesticCount;
    data['industrial_commercial_count'] = this.industrialCommercialCount;
    return data;
  }
}

class DistrictData {
  String? id;
  String? name;
  String? schema;

  DistrictData({this.id, this.name, this.schema});

  DistrictData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    schema = json['schema'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['schema'] = this.schema;
    return data;
  }
}
