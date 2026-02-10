import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/model/filter_key_enum.dart';
import 'package:outage_app/features/Manage/IncidentManage/domain/model/ViewIncidentModel.dart';

class AppConfig {
  static AppConfig? instance;

  Client? client;
  LoginModel loginData = LoginModel();
  ViewIncidentData viewIncidentData = ViewIncidentData();
  DistrictData districtData = DistrictData();
  GridData gridData = GridData();

  Map<String, String> diaColors = {};

  String _baseURL = "";
  String get baseURL => _baseURL;

  String _gaId = "";
  String get gaId => _gaId;

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

  dynamic data = "";
  FilterKey? filterKey;

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
  setDiaColor({required Map<String, String> newDiaColors}) {
    this.diaColors = newDiaColors;
  }


  setDistrictData({required DistrictData districtData}) {
    this.districtData = districtData;
  }

  setGridData({required GridData gridData}) {
    this.gridData = gridData;
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

  void setData({required dynamic newData}) {
    data = newData;
    print("newData : $newData");
  }

  void setFilterByKey({required FilterKey filterByKey}) {
    filterKey = filterByKey;
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
