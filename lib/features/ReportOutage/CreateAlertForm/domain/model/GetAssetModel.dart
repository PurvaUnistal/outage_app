class GetAssetModel {
  int? success;
  bool? error;
  List<GetAssetData>? data;

  GetAssetModel({this.success, this.error, this.data});

  GetAssetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <GetAssetData>[];
      json['data'].forEach((v) {
        data!.add(new GetAssetData.fromJson(v));
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

class GetAssetData {
  String? id;
  String? assetName;
  String? description;
  dynamic createdBy;
  dynamic updatedBy;
  String? createdAt;
  dynamic updatedAt;
  String? assetId;
  String? status;

  GetAssetData(
      {this.id,
        this.assetName,
        this.description,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.assetId,
        this.status});

  GetAssetData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    assetName = json['asset_name'] ?? "";
    description = json['description'] ?? "";
    createdBy = json['created_by'] ?? "";
    updatedBy = json['updated_by'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    assetId = json['asset_id'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['asset_name'] = this.assetName;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['asset_id'] = this.assetId;
    data['status'] = this.status;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return assetName.toString();
  }
}
