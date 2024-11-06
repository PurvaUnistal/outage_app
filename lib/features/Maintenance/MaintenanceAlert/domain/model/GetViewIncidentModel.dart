class ViewIncidentModel {
  int? success;
  bool? error;
  List<ViewIncidentData>? data;

  ViewIncidentModel({this.success, this.error, this.data});

  ViewIncidentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <ViewIncidentData>[];
      json['data'].forEach((v) {
        data!.add(new ViewIncidentData.fromJson(v));
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

class ViewIncidentData {
  String? incid;
  String? areaName;
  String? incidentpriority;
  String? indicationname;
  String? incidenttype;
  String? informationsource;
  String? modulename;
  String? priority;
  String? id;
  String? moduleId;
  String? incidentTypeId;
  String? priorityId;
  String? informationSourceId;
  String? chargeAreaId;
  String? areaId;
  String? indicationId;
  String? locationSource;
  String? address;
  String? landmark;
  String? description;
  String? remarks;
  String? createdBy;
  dynamic updatedBy;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? actionStatus;
  String? actionStatusStartDate;
  String? actionStatusEndDate;
  String? latitude;
  String? longitude;
  String? source;
  dynamic attachFile;
  dynamic customerType;
  String? customerId;
  String? assetTypeId;
  String? assetInternalId;
  dynamic locationGeom;
  String? securityGuardId;
  String? securityGuardName;
  String? securityGuardMobile;
  String? infoCustomerId;
  dynamic infoCustomerName;
  dynamic infoCustomerMobile;
  dynamic infoCustomerBpnumber;
  dynamic otherName;
  dynamic customerTypeData;
  String? incedentId;

  ViewIncidentData(
      {this.incid,
        this.areaName,
        this.incidentpriority,
        this.indicationname,
        this.incidenttype,
        this.informationsource,
        this.modulename,
        this.priority,
        this.id,
        this.moduleId,
        this.incidentTypeId,
        this.priorityId,
        this.informationSourceId,
        this.chargeAreaId,
        this.areaId,
        this.indicationId,
        this.locationSource,
        this.address,
        this.landmark,
        this.description,
        this.remarks,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.actionStatus,
        this.actionStatusStartDate,
        this.actionStatusEndDate,
        this.latitude,
        this.longitude,
        this.source,
        this.attachFile,
        this.customerType,
        this.customerId,
        this.assetTypeId,
        this.assetInternalId,
        this.locationGeom,
        this.securityGuardId,
        this.securityGuardName,
        this.securityGuardMobile,
        this.infoCustomerId,
        this.infoCustomerName,
        this.infoCustomerMobile,
        this.infoCustomerBpnumber,
        this.otherName,
        this.customerTypeData,
        this.incedentId});

  ViewIncidentData.fromJson(Map<String, dynamic> json) {
    incid = json['incid'];
    areaName = json['area_name'];
    incidentpriority = json['incidentpriority'];
    indicationname = json['indicationname'];
    incidenttype = json['incidenttype'];
    informationsource = json['informationsource'];
    modulename = json['modulename'];
    priority = json['priority'];
    id = json['id'];
    moduleId = json['module_id'];
    incidentTypeId = json['incident_type_id'];
    priorityId = json['priority_id'];
    informationSourceId = json['information_source_id'];
    chargeAreaId = json['charge_area_id'];
    areaId = json['area_id'];
    indicationId = json['indication_id'];
    locationSource = json['location_source'];
    address = json['address'];
    landmark = json['landmark'];
    description = json['description'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    actionStatus = json['action_status'];
    actionStatusStartDate = json['action_status_start_date'];
    actionStatusEndDate = json['action_status_end_date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    source = json['source'];
    attachFile = json['attach_file'];
    customerType = json['customer_type'];
    customerId = json['customer_id'];
    assetTypeId = json['asset_type_id'];
    assetInternalId = json['asset_internal_id'];
    locationGeom = json['location_geom'];
    securityGuardId = json['security_guard_id'];
    securityGuardName = json['security_guard_name'];
    securityGuardMobile = json['security_guard_mobile'];
    infoCustomerId = json['info_customer_id'];
    infoCustomerName = json['info_customer_name'];
    infoCustomerMobile = json['info_customer_mobile'];
    infoCustomerBpnumber = json['info_customer_bpnumber'];
    otherName = json['other_name'];
    customerTypeData = json['customer_type_data'];
    incedentId = json['incedent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incid'] = this.incid;
    data['area_name'] = this.areaName;
    data['incidentpriority'] = this.incidentpriority;
    data['indicationname'] = this.indicationname;
    data['incidenttype'] = this.incidenttype;
    data['informationsource'] = this.informationsource;
    data['modulename'] = this.modulename;
    data['priority'] = this.priority;
    data['id'] = this.id;
    data['module_id'] = this.moduleId;
    data['incident_type_id'] = this.incidentTypeId;
    data['priority_id'] = this.priorityId;
    data['information_source_id'] = this.informationSourceId;
    data['charge_area_id'] = this.chargeAreaId;
    data['area_id'] = this.areaId;
    data['indication_id'] = this.indicationId;
    data['location_source'] = this.locationSource;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['description'] = this.description;
    data['remarks'] = this.remarks;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['action_status'] = this.actionStatus;
    data['action_status_start_date'] = this.actionStatusStartDate;
    data['action_status_end_date'] = this.actionStatusEndDate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['source'] = this.source;
    data['attach_file'] = this.attachFile;
    data['customer_type'] = this.customerType;
    data['customer_id'] = this.customerId;
    data['asset_type_id'] = this.assetTypeId;
    data['asset_internal_id'] = this.assetInternalId;
    data['location_geom'] = this.locationGeom;
    data['security_guard_id'] = this.securityGuardId;
    data['security_guard_name'] = this.securityGuardName;
    data['security_guard_mobile'] = this.securityGuardMobile;
    data['info_customer_id'] = this.infoCustomerId;
    data['info_customer_name'] = this.infoCustomerName;
    data['info_customer_mobile'] = this.infoCustomerMobile;
    data['info_customer_bpnumber'] = this.infoCustomerBpnumber;
    data['other_name'] = this.otherName;
    data['customer_type_data'] = this.customerTypeData;
    data['incedent_id'] = this.incedentId;
    return data;
  }
}
