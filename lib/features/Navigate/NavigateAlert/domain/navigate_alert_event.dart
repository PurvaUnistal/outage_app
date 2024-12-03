import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
abstract class NavigateAlertEvent extends Equatable{}

class NavigateAlertLoadEvent extends NavigateAlertEvent {
  final BuildContext context;
  NavigateAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectMapTypeButtonEvent extends NavigateAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectCurrentMarkerButtonEvent extends NavigateAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectGoogleMapButtonEvent extends NavigateAlertEvent {
  final LatLng latLngOnTap;
  final BuildContext context;
  SelectGoogleMapButtonEvent({required this.latLngOnTap, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [latLngOnTap,context];
}
class SelectFilterButtonEvent extends NavigateAlertEvent {
  final BuildContext context;
  SelectFilterButtonEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}


class SelectCheckBoxTFGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxTf;
  SelectCheckBoxTFGisEvent({required this.context, required this.checkBoxTf});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxTf];
}

class SelectTFGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String tfGisId;
  SelectTFGisEvent({required this.context, required this.tfGisId});
  @override
  // TODO: implement props
  List<Object> get props => [context, tfGisId];
}

class SelectValveGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasValveGISId;
  SelectValveGISValueEvent({required this.context, required this.gasValveGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasValveGISId];
}

class SelectCheckBoxValveGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxValve;
  SelectCheckBoxValveGisEvent({required this.context, required this.checkBoxValve});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxValve];
}

class SelectRegulatorGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasRegulatorGISId;
  SelectRegulatorGISValueEvent({required this.context, required this.gasRegulatorGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasRegulatorGISId];
}

class SelectCheckBoxRegulatorGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxRegulator;
  SelectCheckBoxRegulatorGisEvent({required this.context, required this.checkBoxRegulator});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxRegulator];
}


class SelectTeeGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasTeeGISId;
  SelectTeeGISValueEvent({required this.context, required this.gasTeeGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasTeeGISId];
}

class SelectCheckBoxTeeGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxTee;
  SelectCheckBoxTeeGisEvent({required this.context, required this.checkBoxTee});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxTee];
}
class SelectElbowGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasElbowGISId;
  SelectElbowGISValueEvent({required this.context, required this.gasElbowGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasElbowGISId];
}

class SelectCheckBoxElbowGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxElbow;
  SelectCheckBoxElbowGisEvent({required this.context, required this.checkBoxElbow});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxElbow];
}
class SelectCouplerGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasCouplerGISId;
  SelectCouplerGISValueEvent({required this.context, required this.gasCouplerGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasCouplerGISId];
}

class SelectCheckBoxCouplerGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxCoupler;
  SelectCheckBoxCouplerGisEvent({required this.context, required this.checkBoxCoupler});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxCoupler];
}
class SelectReducerGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasReducerGISId;
  SelectReducerGISValueEvent({required this.context, required this.gasReducerGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasReducerGISId];
}

class SelectCheckBoxReducerGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxReducer;
  SelectCheckBoxReducerGisEvent({required this.context, required this.checkBoxReducer});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxReducer];
}
class SelectEndCapGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasEndCapGISId;
  SelectEndCapGISValueEvent({required this.context, required this.gasEndCapGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasEndCapGISId];
}

class SelectCheckBoxEndCapGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxEndCap;
  SelectCheckBoxEndCapGisEvent({required this.context, required this.checkBoxEndCap});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxEndCap];
}

class SelectConsumerGISValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String gasConsumerGISId;
  SelectConsumerGISValueEvent({required this.context, required this.gasConsumerGISId});
  @override
  // TODO: implement props
  List<Object> get props => [context, gasConsumerGISId];
}

class SelectCheckBoxConsumerGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkBoxConsumer;
  SelectCheckBoxConsumerGisEvent({required this.context, required this.checkBoxConsumer});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxConsumer];
}