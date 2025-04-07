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

class ManagePageRefreshDataEvent extends ManageAlertEvent {
  final BuildContext context;
  ManagePageRefreshDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class SelectPageSelectDataEvent extends ManageAlertEvent {
  final int index;
  SelectPageSelectDataEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class SelectSearchPriorityEvent extends ManageAlertEvent {
  final String searchPriority;
  SelectSearchPriorityEvent({required this.searchPriority});
  @override
  // TODO: implement props
  List<Object> get props => [searchPriority];
}

