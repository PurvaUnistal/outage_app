
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/model/ViewIncidentModel.dart';

class AppConfig {
  static AppConfig? instance;

  Client? client;
  LoginModel loginData = LoginModel();
  ViewIncidentData viewIncidentData = ViewIncidentData();

  String _baseURL = "";
  String get baseURL => _baseURL;

  String _gaId = "";
  String get gaId => _gaId;

  String _hoSchema = "";
  String get hoSchema => _hoSchema;


  String _emailId = "";
  String get emailId => _emailId;

  String _password = "";
  String get password => _password;

  String _token = "";
  String get token => _token;

  String _appVersion = "";
  String get appVersion => _appVersion;

  String _packageName = "";
  String get packageName => _packageName;

  String _assets = "";
  String get assets => _assets;

  String _assetsTypeId = "";
  String get assetsTypeId => _assetsTypeId;

  String _markerLat = "";
  String get markerLat => _markerLat;

  String _markerLong = "";
  String get markerLong => _markerLong;


  static AppConfig? instanceInit() {
    instance ??= AppConfig();
    return instance;
  }

  setClient({required Client client}) {
    this.client = client;
  }

  void setBaseURL({required String baseURL}) {
    _baseURL = baseURL;
    print("_baseURL : $_baseURL");
  }

  void setEmailId({required String emailId}) {
    _emailId = emailId;
    print("emailId : $_emailId");
  }

  void setPassword({required String password}) {
    _password = password;
    print("password : $_password");
  }

  setLoginData({required LoginModel newLoginData}) {
    this.loginData = newLoginData;
  }

  setGaId({required String gaId}) {
    _gaId = gaId;
    print("gaId : $gaId");
  }

  setHoSchema({required String hoSchema}) {
    _hoSchema = hoSchema;
    print("_hoSchema : $_hoSchema");
  }
  void setToken({required String token}) {
    _password = password;
    print("password : $token");
  }

  void setAppVersion({required String appVersion}) {
    _appVersion = appVersion;
    print("appVersion : $_appVersion");
  }

  void setPackageName({required String packageName}) {
    _packageName = packageName;
    print("packageName : $packageName");
  }

  void setAssets({required String assets}) {
    _assets = assets;
    print("setAssets : $_assets");
  }

  void setAssetsTypeId({required String assetsTypeId}) {
    _assetsTypeId = assetsTypeId;
    print("setAssetsTypeId : $_assetsTypeId");
  }


  void setMarkerPoint({required String newPointMarkerLat, required String newPointMarkerLong}) {
    _markerLat = newPointMarkerLat;
    _markerLong = newPointMarkerLong;
    print("updatePoint : ${_markerLat+_markerLong}");
  }

   setViewIncidentData({required ViewIncidentData newViewIncidentData}) {
    viewIncidentData = newViewIncidentData;
    print("newViewIncidentData : ${newViewIncidentData}");
  }
}
