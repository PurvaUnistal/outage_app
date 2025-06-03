import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final bool isMapDir;
  final bool isPipelineLoader;
  final bool checkBoxTf;
  final bool isGasTfLoader;
  final bool checkBoxValve;
  final bool isGasValveLoader;
  final bool checkBoxRegulator;
  final bool isGasRegulatorLoader;
  final bool checkCommercial;
  final bool isCommercial;
  final bool checkDomestic;
  final bool isDomestic;
  final bool checkIndustrial;
  final bool isIndustrial;
  final String nameofLocation;
  final String role;
  final String baseUrl;
  final CameraPosition position;
  final Completer<GoogleMapController> googleMapController;

  final TextEditingController tfGisController;
  final TextEditingController gasValveGISController;
  final TextEditingController gasRegulatorGISController;
  final TextEditingController commercialController;
  final TextEditingController domesticController;
  final TextEditingController industrialController;


  final List<String> listOfTfGisId;
  final List<String> listOfGasValveGISId;
  final List<String> listOfGasRegulatorGISId;
  final List<String> listOfCommercialId;
  final List<String> listOfDomesticId;
  final List<String> listOfIndustrialId;


  final MapType currentMapType;
  final Set<Marker> markersPointList;
  final LatLng currentPosition;
  final Set<Polyline> polylinePointList;






  FetchNavigateAlertDataState({
    required this.isLoader,
    required this.isMapDir,
    required this.isPipelineLoader,

    required this.checkBoxTf,
    required this.isGasTfLoader,
    required this.checkBoxValve,
    required this.isGasValveLoader,
    required this.checkBoxRegulator,
    required this.isGasRegulatorLoader,
    required this.checkCommercial,
    required this.isCommercial,
    required this.checkDomestic,
    required this.isDomestic,
    required this.checkIndustrial,
    required this.isIndustrial,

    required this.baseUrl,
    required this.nameofLocation,
    required this.role,
    required this.position,
    required this.googleMapController,
    required this.tfGisController,
    required this.gasValveGISController,
    required this.gasRegulatorGISController,
    required this.commercialController,
    required this.domesticController,
    required this.industrialController,


    required this.currentMapType,
    required this.markersPointList,
    required this.currentPosition,
    required this.polylinePointList,


    required this.listOfTfGisId,
    required this.listOfGasValveGISId,
    required this.listOfGasRegulatorGISId,
    required this.listOfCommercialId,
    required this.listOfDomesticId,
    required this.listOfIndustrialId,
  });
  @override
  List<Object> get props => [
    isLoader,
    isMapDir,
    isPipelineLoader,
    checkBoxTf,
    isGasTfLoader,
    checkBoxValve,
    isGasValveLoader,
    checkBoxRegulator,
    isGasRegulatorLoader,
    checkCommercial,
    isCommercial,
    checkDomestic,
    isDomestic,
    checkIndustrial,
    isIndustrial,

    nameofLocation,
    role,

    position,
    googleMapController,
    baseUrl,
    tfGisController,
    gasValveGISController,
    gasRegulatorGISController,
    commercialController,
    domesticController,
    industrialController,

    currentMapType,
    markersPointList,
    currentPosition,
    polylinePointList,

    listOfTfGisId,
    listOfGasValveGISId,
    listOfGasRegulatorGISId,
    listOfCommercialId,
    listOfDomesticId,
    listOfIndustrialId,
  ];
}