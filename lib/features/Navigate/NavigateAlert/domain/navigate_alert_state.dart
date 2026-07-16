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
  final bool isRefresh;
  final bool isMapDir;
  final String nameofLocation;
  final String role;
  final String baseUrl;
  final Completer<GoogleMapController> googleMapController;
  final bool isPipelineLoader;
  final bool checkTf;
  final bool checkValve;
  final bool checkService;
  final bool checkRegulator;
  final bool checkCommercial;
  final bool checkDomestic;
  final bool checkIndustrial;
  final bool isTfLoader;
  final bool isValveLoader;
  final bool isServiceLoader;
  final bool isRegulatorLoader;
  final bool isCommercialLoader;
  final bool isDomesticLoader;
  final bool isIndustrialLoader;
  final MapType currentMapType;
  final LatLng currentPosition;
  final Set<Marker> markersPointList;
  final Set<Polyline> polylinePointList;
  final TextEditingController tfController;
  final TextEditingController valveController;
  final TextEditingController serviceController;
  final TextEditingController regulatorController;
  final TextEditingController commercialController;
  final TextEditingController domesticController;
  final TextEditingController industrialController;
  final TextEditingController emergencyController;
  final List<String> listOfTfId;
  final List<String> listOfValveId;
  final List<String> listOfServiceId;
  final List<String> listOfRegulatorId;
  final List<String> listOfCommercialId;
  final List<String> listOfDomesticId;
  final List<String> listOfIndustrialId;
  final List<String> listOfEmergencyId;

  FetchNavigateAlertDataState({
    required this.isLoader,
    required this.isRefresh,
    required this.isMapDir,
    required this.nameofLocation,
    required this.role,
    required this.baseUrl,
    required this.googleMapController,
    required this.isPipelineLoader,
    required this.checkTf,
    required this.checkValve,
    required this.checkService,
    required this.checkRegulator,
    required this.checkCommercial,
    required this.checkDomestic,
    required this.checkIndustrial,
    required this.isTfLoader,
    required this.isValveLoader,
    required this.isServiceLoader,
    required this.isRegulatorLoader,
    required this.isCommercialLoader,
    required this.isDomesticLoader,
    required this.isIndustrialLoader,
    required this.currentMapType,
    required this.currentPosition,
    required this.markersPointList,
    required this.polylinePointList,
    required this.tfController,
    required this.valveController,
    required this.serviceController,
    required this.regulatorController,
    required this.commercialController,
    required this.domesticController,
    required this.industrialController,
    required this.emergencyController,
    required this.listOfTfId,
    required this.listOfValveId,
    required this.listOfServiceId,
    required this.listOfRegulatorId,
    required this.listOfCommercialId,
    required this.listOfDomesticId,
    required this.listOfIndustrialId,
    required this.listOfEmergencyId,

  });
  @override
  List<Object> get props => [
    isLoader,
    isRefresh,
    isMapDir,
    nameofLocation,
    role,
    baseUrl,
    googleMapController,
    isPipelineLoader,
    checkTf,
    checkValve,
    checkService,
    checkRegulator,
    checkCommercial,
    checkDomestic,
    checkIndustrial,
    isTfLoader,
    isValveLoader,
    isServiceLoader,
    isRegulatorLoader,
    isCommercialLoader,
    isDomesticLoader,
    isIndustrialLoader,
    currentMapType,
    currentPosition,
    markersPointList,
    polylinePointList,
    tfController,
    valveController,
    serviceController,
    regulatorController,
    commercialController,
    domesticController,
    industrialController,
    emergencyController,
    listOfTfId,
    listOfValveId,
    listOfServiceId,
    listOfRegulatorId,
    listOfCommercialId,
    listOfDomesticId,
    listOfIndustrialId,
    listOfEmergencyId,
  ];
}