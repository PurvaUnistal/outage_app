import 'package:outage_app/Utils/commonClass/enums.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

class AppConfig {
  static AppConfig? instance;
  Client? client;

  String _baseURL = "";

  String get baseURL => _baseURL;

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

  User _userInfo = User();
  User get userInfo => _userInfo;

  String _assets = "";
  String get assets => _assets;

  String _assetsTypeId = "";
  String get assetsTypeId => _assetsTypeId;

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

  void setUserInfo({required User userInfo}) {
    _userInfo = userInfo;
    print("setUserInfo : $_userInfo");
  }

  void setAssets({required String assets}) {
    _assets = assets;
    print("setAssets : $_assets");
  }

  void setAssetsTypeId({required String assetsTypeId}) {
    _assetsTypeId = assetsTypeId;
    print("setAssetsTypeId : $_assetsTypeId");
  }
}
