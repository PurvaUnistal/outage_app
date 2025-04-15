import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/model/consumer_affect_model.dart';

abstract class ReportDetailsEvent extends Equatable{}

class ReportDetailsLoadEvent extends ReportDetailsEvent {
  final BuildContext context;
  ReportDetailsLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class ReportDetailUpdateMarker extends ReportDetailsEvent {
  final BuildContext context;
  ReportDetailUpdateMarker({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ReportDetailBlinkValveMarker extends ReportDetailsEvent {
  final ValveData valveData;
  ReportDetailBlinkValveMarker({required this.valveData});
  @override
  // TODO: implement props
  List<Object?> get props => [valveData];

}

class ReportDetailBlinkConsumerMarker extends ReportDetailsEvent {
  final ConsumerBPList consumerBPList;
  ReportDetailBlinkConsumerMarker({required this.consumerBPList});
  @override
  // TODO: implement props
  List<Object?> get props => [consumerBPList];

}

class SubmitBtnEvent extends ReportDetailsEvent {
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


