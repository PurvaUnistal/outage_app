import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/res/singleton.dart';

class Apis {


  static BuildContext? context = Singleton.instanceInit()?.context;

  static final String baseUrl = EnvironmentConfig.of(context!)!.generalUrlBaseFlavour;


  static get loginUrl  => "auth";
  static get areaList => "outage/getAllArea?schema=";
  static get getOutageModule => "outage/get-outage-module?";
  static get getIncidentType => "outage/get-incident-type?";
  static get getIncidentPriority => "outage/get-incident-priority?";
  static get getLocationSource => "outage/get-location-source";
  static get getInformationSource => "outage/get-information-source?";
  static get getIncidentIndication => "outage/get-incident-indication?";
  static get getChargeAreaList => "getChargeAreaList?";
  static get getAllArea => "getAllArea?";
  static get getViewIncident => "outage/view-incident?";
  static get getCustomerLocationSource => "outage/get-customer-location-source";
  static get getAssetLocationSource =>"outage/get-asset-location-source?";
  static get getCustomerDetailByLocation => "outage/get-customer-detail-bylocation?";
  static get getControlRoom => "outage/get-control-room?";
  static get addIncident => "outage/add-incident";
  static get getPipelineGis => "get-pipeline-gis";
  static get getTFGis => "get-tf-gis?";
  static get getGasValueGis => "get-gasvalve-gis?";
  static get getGasServiceGis => "get-servicepoint-gis?";
  static get getRegulatorGis => "get-regulator-gis?";
  static get getConsumerGis => "get-consumer-gis?";
  static get getNonControllableFittingGis =>"get-noncontrolable-fitting-gis?";
  static get getFittingGis => "get-noncontrolable-fitting-gis";
  static get getPipelineNetwork => "get-pipeline-network?";
  static get getPipeline => "get-pipeline?";
  static get getIncidentAction => "outage/get-incident-action?";
  static get getIncidentTypeAction=>"outage/get-incident-type-action-api?";
  static get getValveConsumerAffect =>"outage/get-valve-consumer-affect?";
  static get incidentActionProgress =>"outage/get-incident-action-progress";
  static get diaColor =>"outage/nominaldiacolor?";
  static get districtData =>"outage/get-district-data?";
  static get gridData => "outage/get-grid-data?";
  static get inChargeData => "outage/get-grid-incharge-data?";
  static get emergencySearch => "outage/get-emergency-search?";
}
