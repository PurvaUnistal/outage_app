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


class SelectCameraPositionButtonEvent extends ReportAlertEvent {
  final CameraPosition cameraPosition;
  SelectCameraPositionButtonEvent({required this.cameraPosition});
  @override
  // TODO: implement props
  List<Object> get props => [cameraPosition];
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
