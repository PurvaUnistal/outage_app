import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ManageAlertEvent extends Equatable{}

class ManageAlertLoadEvent extends ManageAlertEvent {
  final BuildContext context;
  ManageAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
class SelectTabChangedEvent extends ManageAlertEvent {
  final int tabIndex;
  final BuildContext context;
  SelectTabChangedEvent({required this.tabIndex, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [tabIndex,context];
}
class SelectReportChangedEvent extends ManageAlertEvent {
  final String incidentTypeId;
  final String incidentId;
  final BuildContext context;
  SelectReportChangedEvent({required this.incidentTypeId,required this.incidentId, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [incidentTypeId,incidentId, context];
}
