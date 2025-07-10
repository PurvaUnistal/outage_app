import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class IncidentManageEvent extends Equatable{}

class IncidentManageLoadEvent extends IncidentManageEvent {
  final BuildContext context;
  IncidentManageLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
class SelectTabChangedEvent extends IncidentManageEvent {
  final int tabIndex;
  final BuildContext context;
  SelectTabChangedEvent({required this.tabIndex, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [tabIndex,context];
}

class ManagePageRefreshDataEvent extends IncidentManageEvent {
  final BuildContext context;
  ManagePageRefreshDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class SelectPageSelectDataEvent extends IncidentManageEvent {
  final int index;
  SelectPageSelectDataEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class SelectSearchPriorityEvent extends IncidentManageEvent {
  final String searchPriority;
  SelectSearchPriorityEvent({required this.searchPriority});
  @override
  // TODO: implement props
  List<Object> get props => [searchPriority];
}

