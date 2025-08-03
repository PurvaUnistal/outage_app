import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IncidentReportEvent extends Equatable {}

class IncidentReportLoadEvent extends IncidentReportEvent {
  final BuildContext context;
  IncidentReportLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectMapTypeButtonEvent extends IncidentReportEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectGoogleMapButtonEvent extends IncidentReportEvent {
  final LatLng latLngOnTap;
  final BuildContext context;
  SelectGoogleMapButtonEvent({
    required this.latLngOnTap,
    required this.context,
  });
  @override
  // TODO: implement props
  List<Object> get props => [latLngOnTap, context];
}

class SelectFilterButtonEvent extends IncidentReportEvent {
  final BuildContext context;
  SelectFilterButtonEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectCheckBoxTFGisEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkBoxTf;
  SelectCheckBoxTFGisEvent({required this.context, required this.checkBoxTf});
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxTf];
}

class SelectTFGisEvent extends IncidentReportEvent {
  final BuildContext context;
  final String tfGisId;
  SelectTFGisEvent({required this.context, required this.tfGisId});
  @override
  // TODO: implement props
  List<Object> get props => [context, tfGisId];
}

class SelectValveGISValueEvent extends IncidentReportEvent {
  final BuildContext context;
  final String gasValveGISId;
  SelectValveGISValueEvent({
    required this.context,
    required this.gasValveGISId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, gasValveGISId];
}

class SelectCheckBoxValveGisEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkBoxValve;
  SelectCheckBoxValveGisEvent({
    required this.context,
    required this.checkBoxValve,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxValve];
}

class SelectRegulatorGISValueEvent extends IncidentReportEvent {
  final BuildContext context;
  final String gasRegulatorGISId;
  SelectRegulatorGISValueEvent({
    required this.context,
    required this.gasRegulatorGISId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, gasRegulatorGISId];
}

class SelectCheckBoxRegulatorGisEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkBoxRegulator;
  SelectCheckBoxRegulatorGisEvent({
    required this.context,
    required this.checkBoxRegulator,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, checkBoxRegulator];
}

class SelectCommercialValueEvent extends IncidentReportEvent {
  final BuildContext context;
  final String commercialId;
  SelectCommercialValueEvent({
    required this.context,
    required this.commercialId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, commercialId];
}

class SelectCheckCommercialEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkCommercial;
  SelectCheckCommercialEvent({
    required this.context,
    required this.checkCommercial,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, checkCommercial];
}

class SelectDomesticValueEvent extends IncidentReportEvent {
  final BuildContext context;
  final String domesticId;
  SelectDomesticValueEvent({required this.context, required this.domesticId});
  @override
  // TODO: implement props
  List<Object> get props => [context, domesticId];
}

class SelectCheckDomesticEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkDomestic;
  SelectCheckDomesticEvent({
    required this.context,
    required this.checkDomestic,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, checkDomestic];
}

class SelectIndustrialValueEvent extends IncidentReportEvent {
  final BuildContext context;
  final String industrialId;
  SelectIndustrialValueEvent({
    required this.context,
    required this.industrialId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, industrialId];
}

class SelectCheckIndustrialEvent extends IncidentReportEvent {
  final BuildContext context;
  final bool checkIndustrial;
  SelectCheckIndustrialEvent({
    required this.context,
    required this.checkIndustrial,
  });
  @override
  // TODO: implement props
  List<Object> get props => [context, checkIndustrial];
}

class SelectGoogleRouteDirEvent extends IncidentReportEvent {
  final BuildContext context;
  final LatLng toLatLng;
  SelectGoogleRouteDirEvent({required this.context, required this.toLatLng});
  @override
  // TODO: implement props
  List<Object> get props => [context, toLatLng];
}

class OnCameraIdleEvent extends IncidentReportEvent {
  final BuildContext context;
  OnCameraIdleEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class ResetFilterEvent extends IncidentReportEvent {
  final BuildContext context;
  ResetFilterEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class CurrentLocationEvent extends IncidentReportEvent {
  final BuildContext context;
  CurrentLocationEvent({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class UpdateStartAddressEvent extends IncidentReportEvent {
  final String startAddress;
  UpdateStartAddressEvent(this.startAddress);

  @override
  // TODO: implement props
  List<Object?> get props => [startAddress];
}

class UpdateDestinationAddressEvent extends IncidentReportEvent {
  final String destinationAddress;
  UpdateDestinationAddressEvent(this.destinationAddress);

  @override
  // TODO: implement props
  List<Object?> get props => [destinationAddress];
}

class SelectCurrentSuggestionEvent extends IncidentReportEvent {
  final String selectedCurrent;
  SelectCurrentSuggestionEvent(this.selectedCurrent);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedCurrent];
}

class SelectDestinationSuggestionEvent extends IncidentReportEvent {
  final String selectedDescription;
  SelectDestinationSuggestionEvent(this.selectedDescription);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedDescription];
}

class ShowRouteButtonEvent extends IncidentReportEvent {
  final BuildContext context;
  ShowRouteButtonEvent({required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class SearchHideShowEvent extends IncidentReportEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SelectEmergencyEvent extends IncidentReportEvent {
  final BuildContext context;
  SelectEmergencyEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectSearchEmergencyEvent extends IncidentReportEvent {
  final String searchEmergency;
  SelectSearchEmergencyEvent({required this.searchEmergency});
  @override
  // TODO: implement props
  List<Object> get props => [searchEmergency];
}

class StopTimerEvent extends IncidentReportEvent {
  @override
  List<Object> get props => [];
}
