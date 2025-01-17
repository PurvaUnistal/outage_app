import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/model/consumer_affect_model.dart';

import '../model/IncidentActionModel.dart';

abstract class ReportDetailsState extends Equatable {}

class ReportDetailsInitialState extends ReportDetailsState {
  @override
  List<Object> get props => [];
}

class ReportDetailsPageLoadState extends ReportDetailsState {
  @override
  List<Object> get props => [];
}


class FetchReportDetailsDataState extends ReportDetailsState {
  final bool isLoader;
  final bool isBtnLoader;
  final String scheme;
  final String userName;
  final String role;
  final String currentActionStatus;
  final String baseUrl;
  final LatLng incidentLocation;
  final ConsumerAffectModel consumerAffectMode;
  final ConsumerData consumerData;
  final List<ValveData> listOfValve;
  final List<ConsumerBPList> listOfConsumer;
  Completer<GoogleMapController> googleMapController;
  final Set<Marker> markersPointList;
  final Set<Polyline> polylinePointList;
  final IncidentActionModel incidentActionModel;
  final List<IncidentActionData> listOfIncidentAction;
  final IncidentTypeActionModel incidentTypeActionModel;
  final List<IncidentTypeAction> listOfIncidentTypeAction;

  FetchReportDetailsDataState({
    required this.isLoader,
    required this.isBtnLoader,
    required this.scheme,
    required this.currentActionStatus,
    required this.baseUrl,
    required this.userName,
    required this.role,
    required this.incidentLocation,
    required this.consumerAffectMode,
    required this.consumerData,
    required this.listOfValve,
    required this.listOfConsumer,
    required this.googleMapController,
    required this.markersPointList,
    required this.polylinePointList,
    required this.incidentActionModel,
    required this.listOfIncidentAction,
    required this.incidentTypeActionModel,
    required this.listOfIncidentTypeAction,
  });
  @override
  List<Object> get props => [
    isLoader,
    isBtnLoader,
    scheme,
    currentActionStatus,
    userName,
    role,
    baseUrl,
    incidentLocation,
    consumerAffectMode,
    consumerData,
    listOfValve,
    listOfConsumer,
    googleMapController,
    markersPointList,
    polylinePointList,
    incidentActionModel,
    listOfIncidentAction,
    incidentTypeActionModel,
    listOfIncidentTypeAction,
  ];
}