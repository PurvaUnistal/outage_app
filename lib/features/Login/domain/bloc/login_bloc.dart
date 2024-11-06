
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/connectivity_helper.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_event.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_state.dart';
import 'package:igl_outage_app/features/Login/domain/model/login_model.dart';
import 'package:igl_outage_app/features/Login/helper/login_helper.dart';

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
            if(res.status == 200 && res.user!.role!.toLowerCase().contains('outage engineer')){
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
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              String appVersion = packageInfo.version;
              await SharedPref.setString(key: PrefsValue.appVersion,value: appVersion);
                Navigator.pushReplacementNamed(
                  event.context,
                  RoutesName.home,
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
