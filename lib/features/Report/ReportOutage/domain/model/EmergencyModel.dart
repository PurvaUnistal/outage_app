class EmergencyModel {
  int? success;
  bool? error;
  List<EmergencyData>? data;

  EmergencyModel({this.success, this.error, this.data});

  EmergencyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data =  (json['data'] as List<dynamic>?)
        ?.map((v) => EmergencyData.fromJson(v))
        .toList() ??
        [];
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
class EmergencyData {
  final String emergencyName;
  final String longitude;
  final String latitude;

  EmergencyData({
    required this.emergencyName,
    required this.longitude,
    required this.latitude,
  });

  factory EmergencyData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EmergencyData(emergencyName: '', longitude: '', latitude: '');
    }
    return EmergencyData(
      emergencyName: json['emergency_name'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergency_name': emergencyName,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
