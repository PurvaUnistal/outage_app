class GetLocationSourceModel {
  String? key;
  String? value;

  GetLocationSourceModel({this.key, this.value, });

  GetLocationSourceModel.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'] ?? "";
  }
  static List<GetLocationSourceModel> mapToList(Map<String, dynamic> mapData) {
    return mapData.entries.map((e) => GetLocationSourceModel(key: e.key, value: e.value)).toList();
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
