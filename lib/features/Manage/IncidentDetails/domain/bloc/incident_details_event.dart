import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/consumer_affect_model.dart';

abstract class IncidentDetailEvent extends Equatable{}

class IncidentDetailLoadEvent extends IncidentDetailEvent {
  final BuildContext context;
  IncidentDetailLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class IncidentDetailUpdateMarker extends IncidentDetailEvent {
  final BuildContext context;
  IncidentDetailUpdateMarker({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class IncidentDetailBlinkValveMarker extends IncidentDetailEvent {
  final ValveData valveData;
  IncidentDetailBlinkValveMarker({required this.valveData});
  @override
  // TODO: implement props
  List<Object?> get props => [valveData];

}

class IncidentDetailBlinkConsumerMarker extends IncidentDetailEvent {
  final ConsumerBPList consumerBPList;
  IncidentDetailBlinkConsumerMarker({required this.consumerBPList});
  @override
  // TODO: implement props
  List<Object?> get props => [consumerBPList];

}

class IncidentDetailOnCameraIdleEvent extends IncidentDetailEvent {
  final BuildContext context;
  IncidentDetailOnCameraIdleEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object> get props => [context,];
}

class SubmitBtnEvent extends IncidentDetailEvent {
  final String actionStatus;
  final String incidentActionId;
  final String row;
  final BuildContext context;
  SubmitBtnEvent({
    required this.context,
    required this.actionStatus,
    required this.incidentActionId,
    required this.row});
  @override
  // TODO: implement props
  List<Object> get props => [context, actionStatus, incidentActionId, row];
}


