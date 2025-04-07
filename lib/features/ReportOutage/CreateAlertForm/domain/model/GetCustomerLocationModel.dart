class GetCustomerLocationModel {
  int? success;
  bool? error;
  List<GetCustomerLocationData>? data;

  GetCustomerLocationModel({this.success, this.error, this.data});

  GetCustomerLocationModel.fromJson(Map<String, dynamic> json) {
    success = json['success' ] ?? "";
    error = json['error' ] ?? "";
    if (json['data'] != null) {
      data = <GetCustomerLocationData>[];
      json['data'].forEach((v) {
        data!.add(new GetCustomerLocationData.fromJson(v));
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

class GetCustomerLocationData {
  String? bpNumber;
  String? mobileNumber;
  String? serialNumber;
  String? dmaId;
  String? chargeAreaId;
  String? areaId;

  GetCustomerLocationData(
      {this.bpNumber,
        this.mobileNumber,
        this.serialNumber,
        this.dmaId,
        this.chargeAreaId,
        this.areaId});

  GetCustomerLocationData.fromJson(Map<String, dynamic> json) {
    bpNumber = json['bp_number' ] ?? "";
    mobileNumber = json['mobile_number' ] ?? "";
    serialNumber = json['serial_number' ] ?? "";
    dmaId = json['dma_id' ] ?? "";
    chargeAreaId = json['charge_area_id' ] ?? "";
    areaId = json['area_id' ] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bp_number'] = this.bpNumber;
    data['mobile_number'] = this.mobileNumber;
    data['serial_number'] = this.serialNumber;
    data['dma_id'] = this.dmaId;
    data['charge_area_id'] = this.chargeAreaId;
    data['area_id'] = this.areaId;
    return data;
  }
}
