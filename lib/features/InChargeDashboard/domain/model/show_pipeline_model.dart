import 'package:hive/hive.dart';


class ShowPipelineModel extends HiveObject {
  @HiveField(0)
  String? userId;

  @HiveField(1)
  String? schema;

  @HiveField(2)
  List<ShowMarkers>? markers;

  @HiveField(3)
  List<ShowPolylines>? polylines;

  @HiveField(4)
  List<ShowPolygonsModel>? polygons;

  ShowPipelineModel({
    this.userId,
    this.schema,
    this.markers,
    this.polylines,
    this.polygons,
  });

  factory ShowPipelineModel.fromJson(Map<String, dynamic> json) {
    return ShowPipelineModel(
      userId: json['user_id'],
      schema: json['schema'],

      markers: (json['markers'] as List?)
          ?.map((e) => ShowMarkers.fromJson(e))
          .toList() ??
          [],

      polylines: (json['polylines'] as List?)
          ?.map((e) => ShowPolylines.fromJson(e))
          .toList() ??
          [],

      polygons: (json['polygons'] as List?)
          ?.map((e) => ShowPolygonsModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'schema': schema,
    'markers': markers?.map((e) => e.toJson()).toList(),
    'polylines': polylines?.map((e) => e.toJson()).toList(),
    'polygons': polygons?.map((e) => e.toJson()).toList(),
  };
}


class ShowMarkers extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  ShowPointModel? point;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  String? type;

  @HiveField(4)
  String? pipelineId;

  @HiveField(5)
  String? name;

  @HiveField(6)
  String? subValue;

  ShowMarkers({
    this.id,
    this.point,
    this.imagePath,
    this.type,
    this.pipelineId,
    this.name,
    this.subValue,
  });

  factory ShowMarkers.fromJson(Map<String, dynamic> json) => ShowMarkers(
    id: json['id'] ?? "",
    point: json['point'] != null
        ? ShowPointModel.fromJson(json['point'])
        : null,
    imagePath: json['image_path'] ?? "",
    type: json['type'] ?? "",
    pipelineId: json['pipeline_id'] ?? "",
    name: json['name'] ?? "",
    subValue: json['sub_value'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'point': point?.toJson(),
    'image_path': imagePath,
    'type': type,
    'pipeline_id': pipelineId,
    'name': name,
    'sub_value': subValue,
  };
  @override
  String toString() {
    // TODO: implement toString
    return name.toString();
  }
}



class ShowPolylines extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<ShowPointModel>? points;

  @HiveField(3)
  int? colorValue;

  @HiveField(4)
  String? discription;

  @HiveField(5)
  String? type;

  @HiveField(6)
  String? userName;

  @HiveField(7)
  String? role;

  ShowPolylines({
    this.id,
    this.name,
    this.points,
    this.colorValue,
    this.discription,
    this.type,
    this.userName,
    this.role,
  });

  factory ShowPolylines.fromJson(Map<String, dynamic> json) => ShowPolylines(
    id: json['id'],
    name: json['name'],
    points: (json['points'] as List?)
        ?.map((e) => ShowPointModel.fromJson(e))
        .toList() ??
        [],
    colorValue: json['colorValue'],
    discription: json['discription'],
    type: json['type'],
    userName: json['user_name'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'points': points?.map((e) => e.toJson()).toList(),
    'colorValue': colorValue,
    'discription': discription,
    'type': type,
    'user_name': userName,
    'role': role,
  };
}

class ShowPolygonsModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<ShowPointModel>? points;

  @HiveField(3)
  int? strokeColorValue;

  @HiveField(4)
  int? fillColorValue;

  @HiveField(5)
  String? discription;

  @HiveField(6)
  String? type;

  @HiveField(7)
  String? userName;

  @HiveField(8)
  String? role;

  ShowPolygonsModel({
    this.id,
    this.name,
    this.points,
    this.strokeColorValue,
    this.fillColorValue,
    this.discription,
    this.type,
    this.userName,
    this.role,
  });

  factory ShowPolygonsModel.fromJson(Map<String, dynamic> json) => ShowPolygonsModel(
    id: json['id'],
    name: json['name'],
    points: (json['points'] as List?)
        ?.map((e) => ShowPointModel.fromJson(e))
        .toList() ??
        [],
    strokeColorValue: json['strokeColorValue'],
    fillColorValue: json['fillColorValue'],
    discription: json['discription'],
    type: json['type'],
    userName: json['user_name'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'points': points?.map((e) => e.toJson()).toList(),
    'strokeColorValue': strokeColorValue,
    'fillColorValue': fillColorValue,
    'discription': discription,
    'type': type,
    'user_name': userName,
    'role': role,
  };
}

class ShowPointModel extends HiveObject {
  @HiveField(0)
  double? lat;

  @HiveField(1)
  double? lng;

  ShowPointModel({this.lat, this.lng});

  factory ShowPointModel.fromJson(Map<String, dynamic> json) => ShowPointModel(
    lat: double.tryParse(json['lat'].toString()),
    lng: double.tryParse(json['lng'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };
}
