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
class SelectGoogleRouteDirEvent extends NavigateAlertEvent {
  final BuildContext context;
  SelectGoogleRouteDirEvent({ required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectCheckBoxTFGisEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkTf;
  SelectCheckBoxTFGisEvent({required this.context, required this.checkTf});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkTf];
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


class SelectCommercialValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String commercialId;
  SelectCommercialValueEvent({required this.context, required this.commercialId});
  @override
  // TODO: implement props
  List<Object> get props => [context, commercialId];
}

class SelectCheckCommercialEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkCommercial;
  SelectCheckCommercialEvent({required this.context, required this.checkCommercial});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkCommercial];
}

class SelectDomesticValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String domesticId;
  SelectDomesticValueEvent({required this.context, required this.domesticId});
  @override
  // TODO: implement props
  List<Object> get props => [context, domesticId];
}

class SelectCheckDomesticEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkDomestic;
  SelectCheckDomesticEvent({required this.context, required this.checkDomestic});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkDomestic];
}

class SelectIndustrialValueEvent extends NavigateAlertEvent {
  final BuildContext context;
  final String industrialId;
  SelectIndustrialValueEvent({required this.context, required this.industrialId});
  @override
  // TODO: implement props
  List<Object> get props => [context, industrialId];
}

class SelectCheckIndustrialEvent extends NavigateAlertEvent {
  final BuildContext context;
  final bool checkIndustrial;
  SelectCheckIndustrialEvent({required this.context, required this.checkIndustrial});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkIndustrial];
}


class NavigateAlertOnCameraIdleEvent extends NavigateAlertEvent {
  final BuildContext context;
  NavigateAlertOnCameraIdleEvent({required this.context,});
  @override
  // TODO: implement props
  List<Object> get props => [context,];
}

class ResetFilterEvent extends NavigateAlertEvent {
  final BuildContext context;
  ResetFilterEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}


class UpdateStartAddress extends NavigateAlertEvent {
  UpdateStartAddress();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class UpdateDestinationAddress extends NavigateAlertEvent {
  final String destinationAddress;
  UpdateDestinationAddress(this.destinationAddress);

  @override
  // TODO: implement props
  List<Object?> get props => [destinationAddress];
}

class ShowRouteButtonEvent extends NavigateAlertEvent{
  final BuildContext context;
  ShowRouteButtonEvent({required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class SearchDesEvent extends NavigateAlertEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SelectEmergencyEvent extends NavigateAlertEvent {
  final BuildContext context;
  SelectEmergencyEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectSearchEmergencyEvent extends NavigateAlertEvent {
  final String searchEmergency;
  SelectSearchEmergencyEvent({required this.searchEmergency});
  @override
  // TODO: implement props
  List<Object> get props => [searchEmergency];
}