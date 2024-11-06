class GetIncidentTypeModel {
  int? success;
  bool? error;
  List<GetIncidentTypeData>? data;

  GetIncidentTypeModel({this.success, this.error, this.data});

  GetIncidentTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success' ] ?? "";
    error = json['error' ] ?? "";
    if (json['data'] != null) {
      data = <GetIncidentTypeData>[] ;
      json['data'].forEach((v) {
        data!.add(new GetIncidentTypeData.fromJson(v));
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

class GetIncidentTypeData {
  String? id;
  String? alertName;

  GetIncidentTypeData({this.id, this.alertName});

  GetIncidentTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id' ] ?? "";
    alertName = json['alert_name' ] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alert_name'] = this.alertName;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return alertName.toString();
  }
}
