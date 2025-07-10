import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class InChargeDashboardEvent extends Equatable{}

class InChargeDashboardPageLoadEvent extends InChargeDashboardEvent {
  final BuildContext context;
  InChargeDashboardPageLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
