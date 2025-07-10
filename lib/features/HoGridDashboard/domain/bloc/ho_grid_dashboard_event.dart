import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HoGridDashboardEvent extends Equatable{}

class HoGridDashboardPageLoadEvent extends HoGridDashboardEvent {
  final BuildContext context;
  HoGridDashboardPageLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
