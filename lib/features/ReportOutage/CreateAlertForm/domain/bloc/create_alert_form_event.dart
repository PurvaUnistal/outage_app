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



class SelectIncidentTypeValueEvent extends CreateAlertFormEvent {
  final GetIncidentTypeData incidentTypeValue;
  final BuildContext context;
  SelectIncidentTypeValueEvent({required this.incidentTypeValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentTypeValue,context];
}


class SelectIncidentIndicationValueEvent extends CreateAlertFormEvent {
  final GetIncidentIndicationData incidentIndicationValue;
  final BuildContext context;
  SelectIncidentIndicationValueEvent({required this.incidentIndicationValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentIndicationValue,context];
}

class SelectAssetValueEvent extends CreateAlertFormEvent {
  final GetAssetData assetValue;
  final BuildContext context;
  SelectAssetValueEvent({required this.assetValue, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [assetValue,context];
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

class SelectAudioEvent extends CreateAlertFormEvent {
  final String audioPath;
  SelectAudioEvent({required this.audioPath});
  @override
  // TODO: implement props
  List<Object> get props => [audioPath];
}

class SubmitAddIncidentBtnEvent extends CreateAlertFormEvent {
  final BuildContext context;
  SubmitAddIncidentBtnEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

