import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import '../model/GetAssetModel.dart';
import '../model/GetIncidentIndicationModel.dart';

abstract class CreateAlertFormState extends Equatable {}

class CreateAlertFormInitialState extends CreateAlertFormState {
  @override
  List<Object> get props => [];
}

class CreateAlertFormPageLoadState extends CreateAlertFormState {
  @override
  List<Object> get props => [];
}

class FetchCreateAlertFormDataState extends CreateAlertFormState {
  final File photo;
  final File audioRecordFile;
  final bool isLoader;
  final bool isBtnLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;

  final GetIncidentTypeModel incidentTypeModel;
  final GetIncidentTypeData incidentTypeValue;
  final List<GetIncidentTypeData> listOfIncidentType;

  final GetIncidentIndicationModel incidentIndicationModel;
  final GetIncidentIndicationData incidentIndicationValue;
  final List<GetIncidentIndicationData> listOfIncidentIndication;

  final GetAssetModel assetModel;
  final GetAssetData assetValue;
  final List<GetAssetData> listOfAsset;

  final TextEditingController assetIdController;
  final TextEditingController valveGisIdController;
  final TextEditingController tfGisIdController;
  final TextEditingController markerLatitudeController;
  final TextEditingController markerLongitudeController;
  final TextEditingController currentLatitudeController;
  final TextEditingController currentLongitudeController;
  final TextEditingController assetTypeIdController;
  final TextEditingController addressController;
  final TextEditingController landmarkController;
  final TextEditingController descriptionController;
  final TextEditingController remarksController;

  FetchCreateAlertFormDataState({
    required this.photo,
    required this.audioRecordFile,
    required this.isLoader,
    required this.isBtnLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
    required this.incidentTypeModel,
    required this.incidentTypeValue,
    required this.listOfIncidentType,
    required this.assetModel,
    required this.assetValue,
    required this.listOfAsset,
    required this.incidentIndicationModel,
    required this.incidentIndicationValue,
    required this.listOfIncidentIndication,
    required this.assetTypeIdController,
    required this.valveGisIdController,
    required this.assetIdController,
    required this.tfGisIdController,
    required this.markerLatitudeController,
    required this.markerLongitudeController,
    required this.currentLatitudeController,
    required this.currentLongitudeController,
    required this.addressController,
    required this.landmarkController,
    required this.descriptionController,
    required this.remarksController,
  });

  @override
  List<Object?> get props => [
        photo,
        audioRecordFile,
        isLoader,
        isBtnLoader,
        scheme,
        userName,
        role,
        baseUrl,
        incidentTypeModel,
        incidentTypeValue,
        listOfIncidentType,
        assetModel,
        assetValue,
        listOfAsset,
        incidentIndicationModel,
        incidentIndicationValue,
        listOfIncidentIndication,
        assetTypeIdController,
        tfGisIdController,
        valveGisIdController,
        assetIdController,
        markerLatitudeController,
        markerLongitudeController,
        currentLatitudeController,
        currentLongitudeController,
        addressController,
        landmarkController,
        descriptionController,
        remarksController,
      ];
}
