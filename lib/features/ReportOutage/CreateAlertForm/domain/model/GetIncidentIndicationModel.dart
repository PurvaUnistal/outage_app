class GetIncidentIndicationModel {
  int? success;
  bool? error;
  List<GetIncidentIndicationData>? data;

  GetIncidentIndicationModel({this.success, this.error, this.data});

  GetIncidentIndicationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    error = json['error'] ?? "";
    if (json['data'] != null) {
      data = <GetIncidentIndicationData>[];
      json['data'].forEach((v) {
        data!.add(new GetIncidentIndicationData.fromJson(v));
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

class GetIncidentIndicationData {
  String? id;
  String? name;

  GetIncidentIndicationData({this.id, this.name});

  GetIncidentIndicationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return name.toString();
  }
}
