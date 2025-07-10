
import 'dart:convert';

List<String> diaColorModelFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String diaColorModelToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));



class DiaColorModel {
  String? key;
  String? value;

  DiaColorModel({this.key, this.value, });

  DiaColorModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  static List<DiaColorModel> mapToList(Map<String, dynamic> mapData) {
    return mapData.entries.map((e) => DiaColorModel(key: e.key, value: e.value)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }



  @override
  String toString() {
    // TODO: implement toString
    return value ?? "";
  }
}