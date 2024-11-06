import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

abstract class ReportAlertState extends Equatable {}

class ReportAlertInitialState extends ReportAlertState {
  @override
  List<Object> get props => [];
}

class ReportAlertPageLoadState extends ReportAlertState {
  @override
  List<Object> get props => [];
}


class FetchReportAlertDataState extends ReportAlertState {
  final bool isLoader;
  final bool isPipelineLoader;
  final String scheme;
  final String userName;
  final String nameofLocation;
  final String role;
  final String baseUrl;
  final TextEditingController tfGisController;
  final TextEditingController gasValveGISController;
  final List<String> listOfGasValveGISId;
  final List<String> listOfTfGisId;
  final MapType currentMapType;
  final Set<Marker> markersPointList;
  final LatLng currentPosition;
  final LatLng loginPosition;
  final Set<Polyline> polylineList;
  final GetTfGisModel tfGisModel;
  final List<TfGisData> listOfTfGis;
  final GetPipelineNetworkModel pipelineNetworkModel;
  final PipelineNetworkData pipelineNetworkData;
  final List<PipelineNetworkData> listOfPipelineNetwork;
  final List<TfGisData> listOfGasValueGIS;


  FetchReportAlertDataState({
    required this.isLoader,
    required this.isPipelineLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.nameofLocation,
    required this.role,
    required this.tfGisController,
    required this.gasValveGISController,
    required this.listOfTfGisId,
    required this.currentMapType,
    required this.markersPointList,
    required this.currentPosition,
    required this.loginPosition,
    required this.polylineList,
    required this.tfGisModel,
    required this.listOfTfGis,
    required this.pipelineNetworkModel,
    required this.pipelineNetworkData,
    required this.listOfPipelineNetwork,
    required this.listOfGasValveGISId,
    required this.listOfGasValueGIS,
  });
  @override
  List<Object> get props => [
    isLoader,
    isPipelineLoader,
    scheme,
    userName,
    nameofLocation,
    role,
    baseUrl,
    tfGisController,
    gasValveGISController,
    listOfTfGisId,
    currentMapType,
    markersPointList,
    currentPosition,
    loginPosition,
    polylineList,
    tfGisModel,
    listOfTfGis,
    pipelineNetworkModel,
    pipelineNetworkData,
    listOfPipelineNetwork,
    listOfGasValveGISId,
    listOfGasValueGIS,
  ];
}