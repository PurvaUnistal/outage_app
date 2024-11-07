import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import '../model/GetAreaModel.dart';
import '../model/GetAssetModel.dart';
import '../model/GetChargeAreaModel.dart';
import '../model/GetControlRoomModel.dart';
import '../model/GetIncidentIndicationModel.dart';
import '../model/GetIncidentTypeModel.dart';
import '../model/GetLocationSourceModel.dart';
import '../model/GetModuleTypeModel.dart';
import '../model/GetPriorityTypeModel.dart';

abstract class CreateAlertFormEvent extends Equatable{}

class CreateAlertFormLoadEvent extends CreateAlertFormEvent {
  final BuildContext context;
  CreateAlertFormLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectModuleValueEvent extends CreateAlertFormEvent {
  final GetModuleTypeData moduleTypeValue;
  final BuildContext context;
  SelectModuleValueEvent({required this.moduleTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [moduleTypeValue,context];
}

class SelectIncidentTypeValueEvent extends CreateAlertFormEvent {
  final GetIncidentTypeData incidentTypeValue;
  final BuildContext context;
  SelectIncidentTypeValueEvent({required this.incidentTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentTypeValue,context];
}


class SelectPriorityTypeValueEvent extends CreateAlertFormEvent {
  final GetPriorityTypeData priorityTypeValue;
  final BuildContext context;
  SelectPriorityTypeValueEvent({required this.priorityTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [priorityTypeValue,context];
}


class SelectLocationSourceValueEvent extends CreateAlertFormEvent {
  final GetLocationSourceModel locationSourceValue;
  final BuildContext context;
  SelectLocationSourceValueEvent({required this.locationSourceValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [locationSourceValue,context];
}


class SelectInformationSourceValueEvent extends CreateAlertFormEvent {
  final GetPriorityTypeData informationSourceValue;
  final BuildContext context;
  SelectInformationSourceValueEvent({required this.informationSourceValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [informationSourceValue,context];
}
class SelectIncidentIndicationValueEvent extends CreateAlertFormEvent {
  final GetIncidentIndicationData incidentIndicationValue;
  final BuildContext context;
  SelectIncidentIndicationValueEvent({required this.incidentIndicationValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentIndicationValue,context];
}
class SelectChargeAreaValueEvent extends CreateAlertFormEvent {
  final GetChargeAreaModel chargeAreaValue;
  final BuildContext context;
  SelectChargeAreaValueEvent({required this.chargeAreaValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [chargeAreaValue,context];
}
class SelectAreaValueEvent extends CreateAlertFormEvent {
  final GetAreaModel areaValue;
  final BuildContext context;
  SelectAreaValueEvent({required this.areaValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [areaValue,context];
}

class SelectControlRoomValueEvent extends CreateAlertFormEvent {
  final GetControlRoomData controlRoomValue;
  final BuildContext context;
  SelectControlRoomValueEvent({required this.controlRoomValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [controlRoomValue,context];
}

class SelectCustomerTypeValueEvent extends CreateAlertFormEvent {
  final GetLocationSourceModel customerTypeValue;
  final BuildContext context;
  SelectCustomerTypeValueEvent({required this.customerTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [customerTypeValue,context];
}

class SelectSearchNumberControllerEvent extends CreateAlertFormEvent {
  final BuildContext context;
  final String searchNumberValue;
  SelectSearchNumberControllerEvent({required this.context, required this.searchNumberValue});
  @override
  // TODO: implement props
  List<Object> get props => [context,searchNumberValue];
}

class SelectAssetValueEvent extends CreateAlertFormEvent {
  final GetAssetData assetDataValue;
  final BuildContext context;
  SelectAssetValueEvent({required this.assetDataValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [assetDataValue,context];
}
class SelectAssetTypeIdValueEvent extends CreateAlertFormEvent {
  final TfGisData assetTypeIdValue;
  final BuildContext context;
  SelectAssetTypeIdValueEvent({required this.assetTypeIdValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [assetTypeIdValue,context];
}

class CaptureCameraPhotoEvent extends CreateAlertFormEvent {

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CaptureGalleryPhotoEvent extends CreateAlertFormEvent {

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SubmitAddIncidentBtnEvent extends CreateAlertFormEvent {
  final BuildContext context;
  SubmitAddIncidentBtnEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

