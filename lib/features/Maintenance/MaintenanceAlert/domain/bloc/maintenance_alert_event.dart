import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MaintenanceAlertEvent extends Equatable{}

class MaintenanceAlertLoadEvent extends MaintenanceAlertEvent {
  final BuildContext context;
  MaintenanceAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}



