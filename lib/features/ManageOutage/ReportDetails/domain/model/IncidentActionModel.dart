class IncidentActionModel {
  int? success;
  bool? error;
  List<IncidentActionData>? data;

  IncidentActionModel({this.success, this.error, this.data});

  IncidentActionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    error = json['error'] ?? "";
    if (json['data'] != null) {
      data = <IncidentActionData>[];
      json['data'].forEach((v) {
        data!.add(new IncidentActionData.fromJson(v));
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

class IncidentActionData {
  String? id;
  String? incidentTypeId;
  String? moduleId;
  String? name;
  String? description;
  String? createdBy;
  dynamic updatedBy;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? sortOrder;

  IncidentActionData(
      {this.id,
        this.incidentTypeId,
        this.moduleId,
        this.name,
        this.description,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.sortOrder});

  IncidentActionData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    incidentTypeId = json['incident_type_id'] ?? "";
    moduleId = json['module_id'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    createdBy = json['created_by'] ?? "";
    updatedBy = json['updated_by'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    status = json['status'] ?? "";
    sortOrder = json['sort_order'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['incident_type_id'] = this.incidentTypeId;
    data['module_id'] = this.moduleId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
