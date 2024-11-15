import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ReportDetailsEvent extends Equatable{}

class ReportDetailsLoadEvent extends ReportDetailsEvent {
  final BuildContext context;
  ReportDetailsLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
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


