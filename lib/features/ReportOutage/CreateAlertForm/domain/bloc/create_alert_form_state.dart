import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetLocationSourceModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetPriorityTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

import '../model/GetAreaModel.dart';
import '../model/GetAssetModel.dart';
import '../model/GetChargeAreaModel.dart';
import '../model/GetControlRoomModel.dart';
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
  final bool isLoader;
  final bool isBtnLoader;
  final bool isModuleLoader;
  final bool isChargeAreaLoader;
  final bool isAreaLoader;
  final bool isCustomerTypeLoader;
  final String scheme;
  final String userName;
  final String role;
  final String baseUrl;
  final GetModuleTypeModel moduleTypeModel;
  final GetModuleTypeData moduleTypeValue;
  final List<GetModuleTypeData> listOfModuleType;
  final GetIncidentTypeModel incidentTypeModel;
  final GetIncidentTypeData incidentTypeValue;
  final List<GetIncidentTypeData> listOfIncidentType;
  final GetPriorityTypeModel priorityTypeModel;
  final GetPriorityTypeData priorityTypeValue;
  final List<GetPriorityTypeData> listOfPriorityType;
  final GetLocationSourceModel locationSourceModel;
  final GetLocationSourceModel locationSourceValue;
  final List<GetLocationSourceModel> listOfLocationSource;
  final GetPriorityTypeModel informationSourceModel;
  final GetPriorityTypeData informationSourceValue;
  final List<GetPriorityTypeData> listOfInformationSource;
  final GetIncidentIndicationModel incidentIndicationModel;
  final GetIncidentIndicationData incidentIndicationValue;
  final List<GetIncidentIndicationData> listOfIncidentIndication;
  final GetChargeAreaModel chargeAreaValue;
  final List<GetChargeAreaModel> listOfChargeArea;
  final GetAreaModel areaValue;

  final List<GetAreaModel> listOfArea;
  final GetLocationSourceModel customerTypeValue;
  final List<GetLocationSourceModel> listOfCustomerType;
  final GetAssetModel assetModel;
  final GetAssetData assetDataValue;
  final List<String> listOfSearchNumber;
  final List<GetAssetData> listOfAssetData;
  final TfGisData assetTypeIdValue;
  final List<TfGisData> listOfAssetTypeId;
  final GetControlRoomModel controlRoomModel;
  final GetControlRoomData controlRoomValue;
  final List<GetControlRoomData> listOfControlRoom;
  final TextEditingController valveGisIdController;
  final TextEditingController tfGisIdController;
  final TextEditingController markerLatitudeController;
  final TextEditingController markerLongitudeController;
  final TextEditingController currentLatitudeController;
  final TextEditingController currentLongitudeController;
  final TextEditingController addressController;
  final TextEditingController landmarkController;
  final TextEditingController descriptionController;
  final TextEditingController remarksController;
  final TextEditingController searchNumberController;
  final TextEditingController locationController;
  final TextEditingController infoSecurityNameController;
  final TextEditingController infoSecurityIdController;
  final TextEditingController infoSecurityMobileController;
  final TextEditingController infoCustomerNameController;
  final TextEditingController infoCustomerBpNumberController;
  final TextEditingController infoCustomerMobileController;
  final TextEditingController infoOtherNameController;

  FetchCreateAlertFormDataState({
    required this.photo,
    required this.isLoader,
    required this.isBtnLoader,
    required this.isModuleLoader,
    required this.isCustomerTypeLoader,
    required this.isChargeAreaLoader,
    required this.isAreaLoader,
    required this.scheme,
    required this.baseUrl,
    required this.userName,
    required this.role,
    required this.moduleTypeModel,
    required this.moduleTypeValue,
    required this.listOfModuleType,
    required this.incidentTypeModel,
    required this.incidentTypeValue,
    required this.listOfIncidentType,
    required this.priorityTypeModel,
    required this.priorityTypeValue,
    required this.listOfPriorityType,
    required this.locationSourceModel,
    required this.locationSourceValue,
    required this.listOfLocationSource,
    required this.informationSourceModel,
    required this.informationSourceValue,
    required this.listOfInformationSource,
    required this.incidentIndicationModel,
    required this.incidentIndicationValue,
    required this.listOfIncidentIndication,
    required this.chargeAreaValue,
    required this.listOfChargeArea,
    required this.areaValue,
    required this.listOfArea,
    required this.customerTypeValue,
    required this.listOfCustomerType,
    required this.assetModel,
    required this.assetDataValue,
    required this.listOfAssetData,
    required this.assetTypeIdValue,
    required this.listOfAssetTypeId,
    required this.listOfSearchNumber,
    required this.controlRoomModel,
    required this.controlRoomValue,
    required this.listOfControlRoom,
    required this.valveGisIdController,
    required this.tfGisIdController,
    required this.markerLatitudeController,
    required this.markerLongitudeController,
    required this.currentLatitudeController,
    required this.currentLongitudeController,
    required this.addressController,
    required this.landmarkController,
    required this.descriptionController,
    required this.remarksController,
    required this.searchNumberController,
    required this.locationController,
    required this.infoSecurityNameController,
    required this.infoSecurityIdController,
    required this.infoSecurityMobileController,
    required this.infoCustomerNameController,
    required this.infoCustomerBpNumberController,
    required this.infoCustomerMobileController,
    required this.infoOtherNameController,
  });

  @override
  List<Object?> get props => [
        photo,
        isLoader,
        isBtnLoader,
        isModuleLoader,
        isChargeAreaLoader,
        isAreaLoader,
        isCustomerTypeLoader,
        scheme,
        userName,
        role,
        baseUrl,
        moduleTypeModel,
        moduleTypeValue,
        listOfModuleType,
        incidentTypeModel,
        incidentTypeValue,
        listOfIncidentType,
        priorityTypeModel,
        priorityTypeValue,
        listOfPriorityType,
        locationSourceModel,
        locationSourceValue,
        listOfLocationSource,
        informationSourceModel,
        informationSourceValue,
        listOfInformationSource,
        incidentIndicationModel,
        incidentIndicationValue,
        listOfIncidentIndication,
        chargeAreaValue,
        listOfChargeArea,
        areaValue,
        listOfArea,
        customerTypeValue,
        listOfCustomerType,
        assetModel,
        assetDataValue,
        listOfAssetData,
        assetTypeIdValue,
        listOfAssetTypeId,
        listOfSearchNumber,
        controlRoomModel,
        controlRoomValue,
        listOfControlRoom,
        tfGisIdController,
    valveGisIdController,
        markerLatitudeController,
        markerLongitudeController,
        currentLatitudeController,
        currentLongitudeController,
        addressController,
        landmarkController,
        descriptionController,
        remarksController,
        searchNumberController,
        locationController,
        infoSecurityNameController,
        infoSecurityIdController,
        infoSecurityMobileController,
        infoCustomerNameController,
        infoCustomerBpNumberController,
        infoCustomerMobileController,
        infoOtherNameController,
      ];
}
