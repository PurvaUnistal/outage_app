class GridDataModel {
  int? success;
  bool? error;
  Dashboard? dashboard;
  List<GridData>? data;

  GridDataModel({this.success, this.error, this.dashboard, this.data});

  GridDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    dashboard = json['dashboard'] != null
        ? new Dashboard.fromJson(json['dashboard'])
        : null;
    if (json['data'] != null) {
      data = <GridData>[];
      json['data'].forEach((v) {
        data!.add(new GridData.fromJson(v));
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

class GridData {
  String? id;
  String? gridName;

  GridData({this.id, this.gridName});

  GridData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gridName = json['grid_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grid_name'] = this.gridName;
    return data;
  }
}
