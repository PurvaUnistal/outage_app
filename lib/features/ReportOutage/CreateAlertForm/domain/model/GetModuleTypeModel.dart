class GetModuleTypeModel {
  int? success;
  bool? error;
  List<GetModuleTypeData>? data;

  GetModuleTypeModel({this.success, this.error, this.data});

  GetModuleTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success' ] ?? "";
    error = json['error' ] ?? "";
    if (json['data'] != null) {
      data = <GetModuleTypeData>[];
      json['data'].forEach((v) {
        data!.add(new GetModuleTypeData.fromJson(v));
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

class GetModuleTypeData {
  String? id;
  String? moduleAlias;

  GetModuleTypeData({this.id, this.moduleAlias});

  GetModuleTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    moduleAlias = json['module_alias'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_alias'] = this.moduleAlias;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return moduleAlias.toString();
  }
}
