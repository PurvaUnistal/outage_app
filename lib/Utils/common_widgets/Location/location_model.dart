LocationModel responseLocationData(dynamic json) {
  return LocationModel.fromJson(Map<String, dynamic>.from(json));
}

class LocationModel {
  String? address;
  double? lat;
  double? long;
  String? city;
  double? accuracy;

  LocationModel({this.address, this.lat, this.long, this.city, this.accuracy});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address']?.toString() ?? "",
      lat: _toDouble(json['lat']),
      long: _toDouble(json['long']),
      city: json['city']?.toString() ?? "",
      accuracy: _toDouble(json['accuracy']),
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'lat': lat,
    'long': long,
    'city': city,
    'accuracy': accuracy,
  };

  /// String / int / double / null — sab ko double mein convert karta hai
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim()) ?? 0.0;
  }
}