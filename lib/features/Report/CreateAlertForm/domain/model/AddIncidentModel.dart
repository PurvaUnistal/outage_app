class AddIncidentModel {
  int? success;
  bool? error;
  String? data;

  AddIncidentModel({this.success, this.error, this.data});

  AddIncidentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    error = json['error' ] ?? "";
    data = json['data' ] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['data'] = this.data;
    return data;
  }
}
