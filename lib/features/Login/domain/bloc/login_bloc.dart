import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/connectivity_helper.dart';
import 'package:outage_app/features/Login/domain/bloc/login_event.dart';
import 'package:outage_app/features/Login/domain/bloc/login_state.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/features/Login/helper/login_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitState()) {
    on<LoginPageLoadingEvent>(_pageLoad);
    on<LoginHideShowPasswordEvent>(_setHideShowPassword);
    on<LoginSubmitDataEvent>(_setSubmitLoginData);
  }


  bool isPageLoader = false;
  bool isPassword = false;



  LoginModel loginModel = LoginModel();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  _pageLoad(LoginPageLoadingEvent event, emit) async {
    emit(LoginInitState());
    isPassword = true;
    isPageLoader = false;
    loginModel = LoginModel();
    emailController.text = "";
    passwordController.text = "";
    _eventCompleted(emit);
  }


  _setHideShowPassword(LoginHideShowPasswordEvent event, emit) {
    isPassword = event.isHideShow;
    _eventCompleted(emit);
  }

  _setSubmitLoginData(LoginSubmitDataEvent event, emit) async {
    if(await ConnectivityHelper.allConnectivityCheck(context: event.context) == false){
      return;
    }
    var validationCheck = await LoginHelper.textFieldValidation(
        email: emailController.text.trim(), password: passwordController.text.trim(), context: event.context);
    if (validationCheck == true) {
      try {
        isPageLoader = true;
        _eventCompleted(emit);
        var res = await LoginHelper.loginData(emailId: emailController.text, password: passwordController.text, context: event.context);
        if (res != null) {
          isPageLoader = false;
          _eventCompleted(emit);
          if (res.user != null) {
            loginModel = res;
          //  if(res.status == 200 && res.user!.role!.toLowerCase().contains('complain management')){
            if(res.status == 200 ){
              await SharedPref.setString(key: PrefsValue.passwordVal,value: emailController.text);
              await SharedPref.setString(key: PrefsValue.emailVal,value: passwordController.text);
              await SharedPref.setString(key: PrefsValue.userId,value: res.user!.id!);
              await SharedPref.setString(key: PrefsValue.token,value: res.token!);
              await SharedPref.setString(key: PrefsValue.schema,value: res.user!.schema!);
              await SharedPref.setString(key: PrefsValue.userName,value: res.user!.name!);
              await SharedPref.setString(key: PrefsValue.userRole,value: res.user!.role!);
              await SharedPref.setString(key: PrefsValue.pwdChanged,value: res.user!.pwdChanged!);
              await SharedPref.setString(key: PrefsValue.loginLat,value: res.user!.gaLatitude!);
              await SharedPref.setString(key: PrefsValue.loginLong,value: res.user!.gaLongitude!);
              await SharedPref.setString(key: PrefsValue.gaId,value: res.user!.gaId!);
              await SharedPref.setString(key: PrefsValue.areas,value: res.user!.areas!);
              List<Accessright> accessrightList = await res.user!.accessright ?? [];
              await SharedPref.setString(key: PrefsValue.accessRight,value: Accessright.jsonFromAccessrightList(accessrightList));
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              await SharedPref.setString(key: PrefsValue.appVersion,value: packageInfo.buildNumber);
                Navigator.pushReplacementNamed(
                  event.context,
                  RoutesName.outageApp,
                );

            }
          }
        } else {
          isPageLoader = false;
          _eventCompleted(emit);
        }
      } catch (e) {
        isPageLoader = false;
        _eventCompleted(emit);
        log("catchLoginBloc-->${e.toString()}");
      }
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<LoginState> emit) {
    emit(LoginFetchDataState(
      isPageLoader: isPageLoader,
      isPassword: isPassword,
      emailController: emailController,
      passwordController: passwordController,
    ));
  }
}
