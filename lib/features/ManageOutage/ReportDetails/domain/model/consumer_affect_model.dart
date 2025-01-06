import 'dart:convert';

ConsumerAffectModel consumerAffectModelFromJson(String str) =>
    ConsumerAffectModel.fromJson(json.decode(str));

String consumerAffectModelToJson(ConsumerAffectModel data) =>
    json.encode(data.toJson());

class ConsumerAffectModel {
  final int? success;
  final bool? error;
  final ConsumerData? data;

  ConsumerAffectModel({
    this.success,
    this.error,
    this.data,
  });

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
  final String? incidentlat;
  final String? incidentlong;
  final dynamic valve;
  final dynamic consumer;

  ConsumerData({
    this.incidentId,
    this.incidentlat,
    this.incidentlong,
    this.valve,
    this.consumer,
  });

  factory ConsumerData.fromJson(Map<String, dynamic> json) => ConsumerData(
        incidentId: json["incidentId"] ?? "",
        incidentlat: json["incidentlat"] ?? "",
        incidentlong: json["incidentlong"] ?? "",

        valve: json["valve"] == null
            ? null
            : json['valve'] is String
                ? json['valve']
                : List<List<ValveData>>.from(json["valve"].map((x) =>
                    List<ValveData>.from(x.map((x) => ValveData.fromJson(x))))),
        consumer: json["Consumer"] == null
            ? null
            : json['Consumer'] is String
                ? json['Consumer']
                : List<ConsumerBPList>.from(
                    json["Consumer"].map((x) => ConsumerBPList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "incidentId": incidentId,
        "incidentlat": incidentlat,
        "incidentlong": incidentlong,
        "valve": List<dynamic>.from(
            valve!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "Consumer": List<dynamic>.from(consumer!.map((x) => x.toJson())),
      };
}

class ConsumerBPList {
  final String? wkt;
  final String? gid;
  final String? bpNumber;
  final String? newOldLatitude;
  final String? newOldLongitude;
  final String? tfNumber;

  ConsumerBPList({
    this.wkt,
    this.gid,
    this.bpNumber,
    this.newOldLatitude,
    this.newOldLongitude,
    this.tfNumber,
  });

  factory ConsumerBPList.fromJson(Map<String, dynamic> json) => ConsumerBPList(
        wkt: json["wkt"] ?? "",
        gid: json["gid"] ?? "",
        bpNumber: json["bp_number"] ?? "",
        newOldLatitude: json["new_old_latitude"] ?? "",
        newOldLongitude: json["new_old_longitude"] ?? "",
        tfNumber: json["tf_number"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "wkt": wkt,
        "gid": gid,
        "bp_number": bpNumber,
        "new_old_latitude": newOldLatitude,
        "new_old_longitude": newOldLongitude,
        "tf_number": tfNumber,
      };
}

class ValveData {
  final String? gid;
  final String? wkt;
  final String? valveId;
  final String? latitude;
  final String? longitude;

  ValveData({
    this.gid,
    this.wkt,
    this.valveId,
    this.latitude,
    this.longitude,
  });

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
