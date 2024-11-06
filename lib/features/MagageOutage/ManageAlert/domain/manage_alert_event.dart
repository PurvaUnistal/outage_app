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
