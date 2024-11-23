import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

abstract class ReportAlertEvent extends Equatable{}

class ReportAlertLoadEvent extends ReportAlertEvent {
  final BuildContext context;
  ReportAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectMapTypeButtonEvent extends ReportAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectCurrentMarkerButtonEvent extends ReportAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectGoogleMapButtonEvent extends ReportAlertEvent {
  final LatLng latLngOnTap;
  final BuildContext context;
  SelectGoogleMapButtonEvent({required this.latLngOnTap, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [latLngOnTap,context];
}
class SelectFilterButtonEvent extends ReportAlertEvent {
  final BuildContext context;
  SelectFilterButtonEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}


class SelectCheckBoxTFGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxTf;
  SelectCheckBoxTFGisEvent({required this.context, required this.checkBoxTf});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxTf];
}

class SelectTFGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final String tfGisId;
  SelectTFGisEvent({required this.context, required this.tfGisId});
  @override
  // TODO: implement props
  List<Object> get props => [context, tfGisId];
}

class SelectValveGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasValveGISId;
  SelectValveGISValueEvent({required this.context, required this.gasValveGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasValveGISId];
}

class SelectCheckBoxValveGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxValve;
  SelectCheckBoxValveGisEvent({required this.context, required this.checkBoxValve});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxValve];
}

class SelectRegulatorGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasRegulatorGISId;
  SelectRegulatorGISValueEvent({required this.context, required this.gasRegulatorGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasRegulatorGISId];
}

class SelectCheckBoxRegulatorGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxRegulator;
  SelectCheckBoxRegulatorGisEvent({required this.context, required this.checkBoxRegulator});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxRegulator];
}


class SelectTeeGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasTeeGISId;
  SelectTeeGISValueEvent({required this.context, required this.gasTeeGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasTeeGISId];
}

class SelectCheckBoxTeeGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxTee;
  SelectCheckBoxTeeGisEvent({required this.context, required this.checkBoxTee});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxTee];
}
class SelectElbowGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasElbowGISId;
  SelectElbowGISValueEvent({required this.context, required this.gasElbowGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasElbowGISId];
}

class SelectCheckBoxElbowGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxElbow;
  SelectCheckBoxElbowGisEvent({required this.context, required this.checkBoxElbow});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxElbow];
}
class SelectCouplerGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasCouplerGISId;
  SelectCouplerGISValueEvent({required this.context, required this.gasCouplerGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasCouplerGISId];
}

class SelectCheckBoxCouplerGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxCoupler;
  SelectCheckBoxCouplerGisEvent({required this.context, required this.checkBoxCoupler});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxCoupler];
}
class SelectReducerGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasReducerGISId;
  SelectReducerGISValueEvent({required this.context, required this.gasReducerGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasReducerGISId];
}

class SelectCheckBoxReducerGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxReducer;
  SelectCheckBoxReducerGisEvent({required this.context, required this.checkBoxReducer});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxReducer];
}
class SelectEndCapGISValueEvent extends ReportAlertEvent {
  final BuildContext context;
  final String gasEndCapGISId;
  SelectEndCapGISValueEvent({required this.context, required this.gasEndCapGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasEndCapGISId];
}

class SelectCheckBoxEndCapGisEvent extends ReportAlertEvent {
  final BuildContext context;
  final bool checkBoxEndCap;
  SelectCheckBoxEndCapGisEvent({required this.context, required this.checkBoxEndCap});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxEndCap];
}