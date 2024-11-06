class LoginModel {
  int? status;
  bool? error;
  String? messages;
  String? token;
  User? user;
  String? exptime;

  LoginModel(
      {this.status,
        this.error,
        this.messages,
        this.token,
        this.user,
        this.exptime});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    error = json['error'] ?? "";
    messages = json['messages'] ?? "";
    token = json['token'] ?? "";
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    exptime = json['exptime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['messages'] = this.messages;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['exptime'] = this.exptime;
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? moduleId;
  String? name;
  String? userStatus;
  String? pwdChanged;
  dynamic modules;
  String? schema;
  String? role;
  dynamic accessright;
  String? gaLatitude;
  String? gaLongitude;
  String? spreadId;
  String? sectionId;

  User(
      {this.id,
        this.email,
        this.moduleId,
        this.name,
        this.userStatus,
        this.pwdChanged,
        this.modules,
        this.schema,
        this.role,
        this.accessright,
        this.gaLatitude,
        this.gaLongitude,
        this.spreadId,
        this.sectionId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    email = json['email'] ?? "";
    moduleId = json['module_id'] ?? "";
    name = json['name'] ?? "";
    userStatus = json['user_status'] ?? "";
    pwdChanged = json['pwd_changed'] ?? "";
    modules = json['modules'] ?? "";
    schema = json['schema'] ?? "";
    role = json['role'] ?? "";
    accessright = json['accessright'] ?? "";
    gaLatitude = json['ga_latitude'] ?? "";
    gaLongitude = json['ga_longitude'] ?? "";
    spreadId = json['spread_id'] ?? "";
    sectionId = json['section_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['module_id'] = this.moduleId;
    data['name'] = this.name;
    data['user_status'] = this.userStatus;
    data['pwd_changed'] = this.pwdChanged;
    data['modules'] = this.modules;
    data['schema'] = this.schema;
    data['role'] = this.role;
    data['accessright'] = this.accessright;
    data['ga_latitude'] = this.gaLatitude;
    data['ga_longitude'] = this.gaLongitude;
    data['spread_id'] = this.spreadId;
    data['section_id'] = this.sectionId;
    return data;
  }
}
