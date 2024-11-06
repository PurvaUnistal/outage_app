
class Apis {


   static String baseUrl = 'http://142.79.231.30:9097/api/';
 // static String baseUrl = 'http://pbgpl.smartgasnet.com/api/';
  static String basePath = 'http://142.79.231.30:9097/';

  static String loginUrl = baseUrl + "auth";
  static String areaList = baseUrl + "outage/getAllArea?schema=";
  static String getOutageModule = baseUrl + "outage/get-outage-module?";
  static String getIncidentType = baseUrl + "outage/get-incident-type?";
  static String getIncidentPriority = baseUrl + "outage/get-incident-priority?";
  static String getLocationSource = baseUrl + "outage/get-location-source";
  static String getInformationSource = baseUrl + "outage/get-information-source?";
  static String getIncidentIndication = baseUrl + "outage/get-incident-indication?";
  static String getChargeAreaList = baseUrl + "getChargeAreaList?";
  static String getAllArea = baseUrl + "getAllArea?";
  static String getViewIncident = baseUrl + "outage/view-incident?";
   static String getCustomerLocationSource = baseUrl + "outage/get-customer-location-source";
   static String getAssetLocationSource = baseUrl + "outage/get-asset-location-source?";
   static String getCustomerDetailByLocation = baseUrl + "outage/get-customer-detail-bylocation?";
   static String getControlRoom = baseUrl + "outage/get-control-room?";
   static String addIncident = baseUrl + "outage/add-incident";
   static String getPipelineGis = baseUrl + "get-pipeline-gis";
   static String getGasValueGis = baseUrl + "get-gasvalve-gis";
   static String getFittingGis = baseUrl + "get-noncontrolable-fitting-gis";
   static String getTFGis = baseUrl + "get-tf-gis";
   static String getPipelineNetwork = baseUrl + "get-pipeline-network?";

}
