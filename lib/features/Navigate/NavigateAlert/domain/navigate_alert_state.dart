import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';

abstract class NavigateAlertState extends Equatable {}

class NavigateAlertInitialState extends NavigateAlertState {
  @override
  List<Object> get props => [];
}

class NavigateAlertPageLoadState extends NavigateAlertState {
  @override
  List<Object> get props => [];
}


class FetchNavigateAlertDataState extends NavigateAlertState {
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
  final String scheme;
  final String userName;
  final String nameofLocation;
  final String role;
  final String baseUrl;
  final CameraPosition cameraPosition;

  final TextEditingController tfGisController;
  final TextEditingController gasValveGISController;
  final TextEditingController gasRegulatorGISController;
  final TextEditingController gasTeeGISController;
  final TextEditingController gasElbowGISController;
  final TextEditingController gasCouplerGISController;
  final TextEditingController gasReducerGISController;
  final TextEditingController gasEndCapGISController;


  final List<String> listOfTfGisId;
  final List<String> listOfGasValveGISId;
  final List<String> listOfGasRegulatorGISId;
  final List<String> listOfGasTeeGISId;
  final List<String> listOfGasElbowGISId;
  final List<String> listOfGasCouplerGISId;
  final List<String> listOfGasReducerGISId;
  final List<String> listOfGasEndCapGISId;

  final MapType currentMapType;
  final Set<Marker> markersPointList;
  final LatLng currentPosition;
  final LatLng loginPosition;
  final Set<Polyline> polylineList;


  final GetPipelineNetworkModel pipelineNetworkModel;
  final PipelineNetworkData pipelineNetworkData;
  final List<PipelineNetworkData> listOfPipelineNetwork;



  FetchNavigateAlertDataState({
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

    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.nameofLocation,
    required this.role,
    required this.cameraPosition,
    required this.tfGisController,
    required this.gasValveGISController,
    required this.gasRegulatorGISController,
    required this.gasTeeGISController,
    required this.gasElbowGISController,
    required this.gasCouplerGISController,
    required this.gasReducerGISController,
    required this.gasEndCapGISController,

    required this.currentMapType,
    required this.markersPointList,
    required this.currentPosition,
    required this.loginPosition,
    required this.polylineList,

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
    scheme,
    userName,
    nameofLocation,
    role,
    cameraPosition,
    baseUrl,
    tfGisController,
    gasValveGISController,
    gasRegulatorGISController,
    gasTeeGISController,
    gasElbowGISController,
    gasCouplerGISController,
    gasReducerGISController,
    gasEndCapGISController,


    currentMapType,
    markersPointList,
    currentPosition,
    loginPosition,
    polylineList,
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
  ];
}