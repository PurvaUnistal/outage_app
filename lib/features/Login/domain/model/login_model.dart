import 'dart:convert';

class LoginModel {
  int? status;
  bool? error;
  String? messages;
  String? token;
  User? user;
  String? exptime;

  LoginModel({
    this.status,
    this.error,
    this.messages,
    this.token,
    this.user,
    this.exptime,
  });

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
  String? password;
  String? moduleId;
  String? name;
  String? userStatus;
  String? pwdChanged;
  String? gaId;
  String? gaLatitude;
  String? gaLongitude;
  dynamic modules;
  String? areas;
  String? chargeareas;
  String? schema;
  List<Accessright>? accessright;
  String? role;
  String? spreadId;
  String? sectionId;
  String? isHo;
  dynamic hoga;

  User({
    this.id,
    this.email,
    this.password,
    this.moduleId,
    this.name,
    this.userStatus,
    this.pwdChanged,
    this.gaId,
    this.gaLatitude,
    this.gaLongitude,
    this.modules,
    this.areas,
    this.chargeareas,
    this.schema,
    this.accessright,
    this.role,
    this.spreadId,
    this.sectionId,
    this.isHo,
    this.hoga,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    moduleId = json['module_id'] ?? "";
    name = json['name'] ?? "";
    userStatus = json['user_status'] ?? "";
    pwdChanged = json['pwd_changed'] ?? "";
    gaId = json['ga_id'] ?? "";
    gaLatitude = json['ga_latitude'] ?? "";
    gaLongitude = json['ga_longitude'] ?? "";
    modules = json['modules'] ?? "";
    areas = json['areas'] ?? "";
    chargeareas = json['chargeareas'] ?? "";
    schema = json['schema'] ?? "";
    if (json['accessright'] != null) {
      accessright = <Accessright>[];
      json['accessright'].forEach((v) {
        accessright!.add(new Accessright.fromJson(v));
      });
    }
    role = json['role'] ?? "";
    spreadId = json['spread_id'] ?? "";
    sectionId = json['section_id'] ?? "";
    isHo = json['is_ho'];
    if (json['hoga'] != null && json['hoga'][0] != "") {
      hoga = <Hoga>[];
      json['hoga'].forEach((v) {
        hoga!.add(new Hoga.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['module_id'] = this.moduleId;
    data['name'] = this.name;
    data['user_status'] = this.userStatus;
    data['pwd_changed'] = this.pwdChanged;
    data['ga_id'] = this.gaId;
    data['ga_latitude'] = this.gaLatitude;
    data['ga_longitude'] = this.gaLongitude;
    data['modules'] = this.modules;
    data['areas'] = this.areas;
    data['chargeareas'] = this.chargeareas;
    data['schema'] = this.schema;
    if (this.accessright != null) {
      data['accessright'] = this.accessright!.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
    data['spread_id'] = this.spreadId;
    data['section_id'] = this.sectionId;
    data['is_ho'] = this.isHo;
    if (this.hoga != null) {
      data['hoga'] = this.hoga!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accessright {
  String? menuCode;
  String? id;
  String? name;
  String? submoduleAlias;
  String? manage;
  String? add;
  String? navigate;

  Accessright({
    this.menuCode,
    this.id,
    this.name,
    this.submoduleAlias,
    this.manage,
    this.add,
    this.navigate,
  });

  static accessrightListFromJson(String json) {
    return List<Accessright>.from(
      jsonDecode(json).map((x) => Accessright.fromJson(x)),
    );
  }

  static jsonFromAccessrightList(List<Accessright> list) {
    return jsonEncode(list);
  }

  Accessright.fromJson(Map<String, dynamic> json) {
    menuCode = json['menu_code'] ?? "";
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    submoduleAlias = json['submodule_alias'] ?? "";
    manage = json['manage'] ?? "";
    add = json['add'] ?? "";
    navigate = json['navigate'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_code'] = this.menuCode;
    data['id'] = this.id;
    data['name'] = this.name;
    data['submodule_alias'] = this.submoduleAlias;
    data['manage'] = this.manage;
    data['add'] = this.add;
    data['navigate'] = this.navigate;
    return data;
  }
}

class Hoga {
  String? id;
  String? name;
  String? schema;

  Hoga({this.id, this.name, this.schema});

  Hoga.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    schema = json['schema'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['schema'] = this.schema;
    return data;
  }
}
