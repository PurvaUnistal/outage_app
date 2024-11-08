import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAreaModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAssetModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetChargeAreaModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetControlRoomModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetLocationSourceModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetPriorityTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

abstract class MaintenanceAlertEvent extends Equatable{}

class MaintenanceAlertLoadEvent extends MaintenanceAlertEvent {
  final BuildContext context;
  MaintenanceAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectModuleValueEvent extends MaintenanceAlertEvent {
  final GetModuleTypeData moduleTypeValue;
  final BuildContext context;
  SelectModuleValueEvent({required this.moduleTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [moduleTypeValue,context];
}

class SelectIncidentTypeValueEvent extends MaintenanceAlertEvent {
  final GetIncidentTypeData incidentTypeValue;
  final BuildContext context;
  SelectIncidentTypeValueEvent({required this.incidentTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentTypeValue,context];
}


class SelectPriorityTypeValueEvent extends MaintenanceAlertEvent {
  final GetPriorityTypeData priorityTypeValue;
  final BuildContext context;
  SelectPriorityTypeValueEvent({required this.priorityTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [priorityTypeValue,context];
}


class SelectLocationSourceValueEvent extends MaintenanceAlertEvent {
  final GetLocationSourceModel locationSourceValue;
  final BuildContext context;
  SelectLocationSourceValueEvent({required this.locationSourceValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [locationSourceValue,context];
}


class SelectInformationSourceValueEvent extends MaintenanceAlertEvent {
  final GetPriorityTypeData informationSourceValue;
  final BuildContext context;
  SelectInformationSourceValueEvent({required this.informationSourceValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [informationSourceValue,context];
}
class SelectIncidentIndicationValueEvent extends MaintenanceAlertEvent {
  final GetIncidentIndicationData incidentIndicationValue;
  final BuildContext context;
  SelectIncidentIndicationValueEvent({required this.incidentIndicationValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentIndicationValue,context];
}
class SelectChargeAreaValueEvent extends MaintenanceAlertEvent {
  final GetChargeAreaModel chargeAreaValue;
  final BuildContext context;
  SelectChargeAreaValueEvent({required this.chargeAreaValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [chargeAreaValue,context];
}
class SelectAreaValueEvent extends MaintenanceAlertEvent {
  final GetAreaModel areaValue;
  final BuildContext context;
  SelectAreaValueEvent({required this.areaValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [areaValue,context];
}

class SelectControlRoomValueEvent extends MaintenanceAlertEvent {
  final GetControlRoomData controlRoomValue;
  final BuildContext context;
  SelectControlRoomValueEvent({required this.controlRoomValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [controlRoomValue,context];
}

class SelectCustomerTypeValueEvent extends MaintenanceAlertEvent {
  final GetLocationSourceModel customerTypeValue;
  final BuildContext context;
  SelectCustomerTypeValueEvent({required this.customerTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [customerTypeValue,context];
}

class SelectSearchNumberControllerEvent extends MaintenanceAlertEvent {
  final BuildContext context;
  final String searchNumberValue;
  SelectSearchNumberControllerEvent({required this.context, required this.searchNumberValue});
  @override
  // TODO: implement props
  List<Object> get props => [context,searchNumberValue];
}

class SelectAssetValueEvent extends MaintenanceAlertEvent {
  final GetAssetData assetDataValue;
  final BuildContext context;
  SelectAssetValueEvent({required this.assetDataValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [assetDataValue,context];
}
class SelectAssetTypeIdValueEvent extends MaintenanceAlertEvent {
  final TfGisData assetTypeIdValue;
  final BuildContext context;
  SelectAssetTypeIdValueEvent({required this.assetTypeIdValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [assetTypeIdValue,context];
}

class CaptureCameraPhotoEvent extends MaintenanceAlertEvent {

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CaptureGalleryPhotoEvent extends MaintenanceAlertEvent {

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SubmitAddIncidentBtnEvent extends MaintenanceAlertEvent {
  final BuildContext context;
  SubmitAddIncidentBtnEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

