import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HoDistrictDashboardEvent extends Equatable{}

class HoDistrictDashboardPageLoadEvent extends HoDistrictDashboardEvent {
  final BuildContext context;
  HoDistrictDashboardPageLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
