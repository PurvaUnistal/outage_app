import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/IncidentTypeActionModel.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/consumer_affect_model.dart';

abstract class IncidentDetailState extends Equatable {}

class IncidentDetailInitialState extends IncidentDetailState {
  @override
  List<Object> get props => [];
}

class IncidentDetailPageLoadState extends IncidentDetailState {
  @override
  List<Object> get props => [];
}


class FetchIncidentDetailDataState extends IncidentDetailState {
  final bool isLoader;
  final bool isBtnLoader;
  final String role;
  final String currentActionStatus;
  final String baseUrl;
  final LatLng incidentLocation;
  final ConsumerAffectModel consumerAffectMode;
  final ConsumerData consumerData;
  final List<ValveData> listOfValve;
  final List<ConsumerBPList> listOfConsumer;
  final Completer<GoogleMapController> googleMapController;
  final Set<Marker> markersPointList;
  final Set<Polyline> polylinePointList;
  final IncidentActionModel incidentActionModel;
  final List<IncidentActionData> listOfIncidentAction;
  final IncidentTypeActionModel incidentTypeActionModel;
  final List<IncidentTypeAction> listOfIncidentTypeAction;

  FetchIncidentDetailDataState({
    required this.isLoader,
    required this.isBtnLoader,
    required this.currentActionStatus,
    required this.baseUrl,
    required this.role,
    required this.incidentLocation,
    required this.consumerAffectMode,
    required this.consumerData,
    required this.listOfValve,
    required this.listOfConsumer,
    required this.googleMapController,
    required this.markersPointList,
    required this.incidentActionModel,
    required this.listOfIncidentAction,
    required this.incidentTypeActionModel,
    required this.listOfIncidentTypeAction,
    required this.polylinePointList,
  });
  @override
  List<Object> get props => [
    isLoader,
    isBtnLoader,
    currentActionStatus,
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
    polylinePointList,
  ];
}