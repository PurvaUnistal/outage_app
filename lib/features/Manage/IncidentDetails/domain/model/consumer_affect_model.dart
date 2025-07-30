import 'dart:convert';

ConsumerAffectModel consumerAffectModelFromJson(String str) =>
    ConsumerAffectModel.fromJson(json.decode(str));

String consumerAffectModelToJson(ConsumerAffectModel data) =>
    json.encode(data.toJson());

class ConsumerAffectModel {
  final int? success;
  final bool? error;
  final ConsumerData? data;

  ConsumerAffectModel({this.success, this.error, this.data});

  factory ConsumerAffectModel.fromJson(Map<String, dynamic> json) =>
      ConsumerAffectModel(
        success: json["success"] ?? "",
        error: json["error"] ?? "",
        data: json["data"] == null ? null : ConsumerData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "data": data!.toJson(),
  };
}

class ConsumerData {
  final String? incidentId;
  final String? latitude;
  final String? longitude;
  final List<ValveData>? valve;
  final List<ConsumerBPList>? consumer;

  ConsumerData({
    this.incidentId,
    this.latitude,
    this.longitude,
    this.valve,
    this.consumer,
  });

  factory ConsumerData.fromJson(Map<String, dynamic> json) => ConsumerData(
    incidentId: json["incidentId"]?.toString(),
    latitude: json["incidentlat"]?.toString(),
    longitude: json["incidentlong"]?.toString(),

    valve: json["valve"] == null || json["valve"] is String
        ? null
        : (json["valve"] as List)
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) => ValveData.fromJson(e))
        .toList(),

    consumer: json["Consumer"] == null || json["Consumer"] is String
        ? null
        : (json["Consumer"] as List)
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) => ConsumerBPList.fromJson(e))
        .toList(),
  );


  Map<String, dynamic> toJson() => {
    "incidentId": incidentId,
    "incidentlat": latitude,
    "incidentlong": longitude,
    "valve": valve!
        .where((x) => x != null)
        .map((x) => x.toJson())
        .toList(),
    "Consumer": consumer
        ?.where((x) => x != null)
        .map((x) => x.toJson())
        .toList(),
  };
}

class ConsumerBPList {
  final String? wkt;
  final String? gid;
  final String? bpNumber;
  final String? latitude;
  final String? longitude;
  final String? tfNumber;

  ConsumerBPList({
    this.wkt,
    this.gid,
    this.bpNumber,
    this.latitude,
    this.longitude,
    this.tfNumber,
  });

  factory ConsumerBPList.fromJson(Map<String, dynamic> json) => ConsumerBPList(
    wkt: json["wkt"] ?? "",
    gid: json["gid"] ?? "",
    bpNumber: json["bp_number"] ?? "",
    latitude: json["new_old_latitude"] ?? "",
    longitude: json["new_old_longitude"] ?? "",
    tfNumber: json["tf_number"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "wkt": wkt,
    "gid": gid,
    "bp_number": bpNumber,
    "new_old_latitude": latitude,
    "new_old_longitude": longitude,
    "tf_number": tfNumber,
  };
}

class ValveData {
  final String? gid;
  final String? wkt;
  final String? valveId;
  final String? latitude;
  final String? longitude;

  ValveData({this.gid, this.wkt, this.valveId, this.latitude, this.longitude});

  factory ValveData.fromJson(Map<String, dynamic> json) => ValveData(
    gid: json["gid"] ?? "",
    wkt: json["wkt"] ?? "",
    valveId: json["valve_id"] ?? "",
    latitude: json["latitude"] ?? "",
    longitude: json["longitude"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "gid": gid,
    "wkt": wkt,
    "valve_id": valveId,
    "latitude": latitude,
    "longitude": longitude,
  };
}
