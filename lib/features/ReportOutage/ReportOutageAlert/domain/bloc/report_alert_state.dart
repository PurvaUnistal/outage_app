import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';

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
  final bool checkBoxTf;
  final bool isGasTfLoader;
  final bool checkBoxValve;
  final bool isGasValveLoader;
  final bool checkBoxRegulator;
  final bool isGasRegulatorLoader;
  final bool checkBoxTee;
  final bool isGasTeeLoader;
  final bool checkBoxElbow;
  final bool isGasElbowLoader;
  final bool checkBoxCoupler;
  final bool isGasCouplerLoader;
  final bool checkBoxReducer;
  final bool isGasReducerLoader;
  final bool checkBoxEndCap;
  final bool isGasEndCapLoader;
  final bool checkBoxConsumer;
  final bool isGasConsumerLoader;
  final String scheme;
  final String userName;
  final String nameofLocation;
  final String role;
  final String baseUrl;
  final CameraPosition cameraPosition;
  Completer<GoogleMapController> googleMapController;

  final TextEditingController tfGisController;
  final TextEditingController gasValveGISController;
  final TextEditingController gasRegulatorGISController;
  final TextEditingController gasTeeGISController;
  final TextEditingController gasElbowGISController;
  final TextEditingController gasCouplerGISController;
  final TextEditingController gasReducerGISController;
  final TextEditingController gasEndCapGISController;
  final TextEditingController gasConsumerGISController;


  final List<String> listOfTfGisId;
  final List<String> listOfGasValveGISId;
  final List<String> listOfGasRegulatorGISId;
  final List<String> listOfGasTeeGISId;
  final List<String> listOfGasElbowGISId;
  final List<String> listOfGasCouplerGISId;
  final List<String> listOfGasReducerGISId;
  final List<String> listOfGasEndCapGISId;
  final List<String> listOfGasConsumerGISId;

  final Set<Circle> circles;
  final MapType currentMapType;
  final Set<Marker> markersPointList;
  final LatLng currentPosition;
  final LatLng loginPosition;
  final Set<Polyline> polylinePointList;


  final GetPipelineNetworkModel pipelineNetworkModel;
  final PipelineNetworkData pipelineNetworkData;
  final List<PipelineNetworkData> listOfPipelineNetwork;



  FetchReportAlertDataState({
    required this.isLoader,
    required this.isPipelineLoader,

    required this.checkBoxTf,
    required this.isGasTfLoader,
    required this.checkBoxValve,
    required this.isGasValveLoader,
    required this.checkBoxRegulator,
    required this.isGasRegulatorLoader,
    required this.checkBoxTee,
    required this.isGasTeeLoader,
    required this.checkBoxElbow,
    required this.isGasElbowLoader,
    required this.checkBoxCoupler,
    required this.isGasCouplerLoader,
    required this.checkBoxReducer,
    required this.isGasReducerLoader,
    required this.checkBoxEndCap,
    required this.isGasEndCapLoader,
    required this.checkBoxConsumer,
    required this.isGasConsumerLoader,

    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.nameofLocation,
    required this.role,
    required this.cameraPosition,
    required this.googleMapController,
    required this.tfGisController,
    required this.gasValveGISController,
    required this.gasRegulatorGISController,
    required this.gasTeeGISController,
    required this.gasElbowGISController,
    required this.gasCouplerGISController,
    required this.gasReducerGISController,
    required this.gasEndCapGISController,
    required this.gasConsumerGISController,

    required this.circles,
    required this.currentMapType,
    required this.markersPointList,
    required this.currentPosition,
    required this.loginPosition,
    required this.polylinePointList,

    required this.pipelineNetworkModel,
    required this.pipelineNetworkData,
    required this.listOfPipelineNetwork,

    required this.listOfTfGisId,
    required this.listOfGasValveGISId,
    required this.listOfGasRegulatorGISId,
    required this.listOfGasTeeGISId,
    required this.listOfGasElbowGISId,
    required this.listOfGasCouplerGISId,
    required this.listOfGasReducerGISId,
    required this.listOfGasEndCapGISId,
    required this.listOfGasConsumerGISId,
  });
  @override
  List<Object?> get props => [
    isLoader,
    isPipelineLoader,
    checkBoxTf,
    isGasTfLoader,
    checkBoxValve,
    isGasValveLoader,
    checkBoxRegulator,
    isGasRegulatorLoader,
    checkBoxTee,
    isGasTeeLoader,
    checkBoxElbow,
    isGasElbowLoader,
    checkBoxCoupler,
    isGasCouplerLoader,
    checkBoxReducer,
    isGasReducerLoader,
    checkBoxEndCap,
    isGasEndCapLoader,
    checkBoxConsumer,
    isGasConsumerLoader,
    scheme,
    userName,
    nameofLocation,
    role,
    cameraPosition,
    googleMapController,
    baseUrl,
    tfGisController,
    gasValveGISController,
    gasRegulatorGISController,
    gasTeeGISController,
    gasElbowGISController,
    gasCouplerGISController,
    gasReducerGISController,
    gasEndCapGISController,
    gasConsumerGISController,


    circles,
    currentMapType,
    markersPointList,
    currentPosition,
    loginPosition,
    polylinePointList,
    pipelineNetworkModel,
    pipelineNetworkData,
    listOfPipelineNetwork,

    listOfTfGisId,
    listOfGasValveGISId,
    listOfGasRegulatorGISId,
    listOfGasTeeGISId,
    listOfGasElbowGISId,
    listOfGasCouplerGISId,
    listOfGasReducerGISId,
    listOfGasEndCapGISId,
    listOfGasConsumerGISId,
  ];
}