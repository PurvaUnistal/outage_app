import 'app_config.dart';
import 'enums.dart';

class AssetPath {

  static appLogo(){
    return AppConfig.instanceInit()!.client == Client.agcl
        ? AssetPath.agclLogo
        :AppConfig.instanceInit()!.client == Client.mahaNagar
        ? AssetPath.mglLogo
        : AppConfig.instanceInit()!.client == Client.purvaBharti
        ? AssetPath.pbgLogo
        : AppConfig.instanceInit()!.client == Client.hpoil
        ? AssetPath.hpOilLogo
        : AssetPath.unistalLogo;
  }


  static String pin_circle_red = 'assets/icons/pin_circle_red.png';
  static String smartgasnetLog = 'assets/icons/smartgasnet_log.png';
  static String agclLogo = 'assets/icons/agcl_logo.png';
  static String agclIcon = 'assets/icons/agcl_icon.png';
  static String pbgLogo = 'assets/icons/pbg_logo.png';
  static String mglLogo = 'assets/icons/mgl_logo.png';
  static String hpOilLogo = 'assets/icons/hp_oil_logo.png';
  static String unistalLogo = 'assets/icons/unistal_logo.png';
  static String iglLogo = 'assets/gis/igl_logo.png';


  static String meter = 'assets/icons/meter.jpg';
  static String tfIcon = 'assets/icons/tf_icon.png';
  static String household = 'assets/icons/household-bills.jpg';
  static String lmcBanner = 'assets/icons/lmc-banner1.png';
  static String pipeback = 'assets/icons/pipeback.jpg';
  static String maintenance = 'assets/images/maintenance.png';
  static String manage = 'assets/images/manage.png';
  static String navigate = 'assets/images/navigate.png';
  static String reportOutage = 'assets/images/reportOutage.png';
  static String tf = 'assets/gis/TF.png';
  static String valve = 'assets/gis/valve.png';
  static String service = 'assets/gis/valve.png';
  static String station = 'assets/gis/cng-station.png';
  //static String coupler = 'assets/gis/coupler.png';
  static String elbow = 'assets/gis/elbow.png';
  static String endcap = 'assets/gis/endcap.png';
  static String pipelineStation = 'assets/gis/gas-pipeline-station.png';
  static String mrs = 'assets/gis/mrs.png';
  static String redusingStation = 'assets/gis/preeser-redusing-station.png';
  static String marker = 'assets/gis/RCC-Marker.png';
  static String reduce = 'assets/gis/reduce.png';
   static String regulator = 'assets/gis/regulator.png';
  static String serviceRegulator = 'assets/gis/service-regulator.png';
  static String tapFitting = 'assets/gis/tap-fitting.png';
  static String tee = 'assets/gis/tee.png';
  static String loginPin = 'assets/gis/location-pin.png';
  static String pin = 'assets/gis/pin.png';
  static String consumer = 'assets/gis/gas_consumer.png';
  static String markerAnimation = 'assets/gis/icons.gif';
  static String consumerBlink = 'assets/gis/consumer_blink.png';
  static String valveBlink = 'assets/gis/valve_blink.png';
}