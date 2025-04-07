import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:outage_app/features/Home/domain/bloc/home_state.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/features/ManageOutage/ManageAlert/presentation/page/manage_alert_page.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/presentation/report_alert_page.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeLoadEvent>(_pageLoad);
  }

  bool isLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';
  List<Accessright> listOFAccessRight = [];
  List<String> paths = [];
  List<String> iconText = [];
  List<Widget> navigatorView = [];

  _pageLoad(HomeLoadEvent event, emit) async {
    emit(HomeInitialState());
    isLoader =  false;
     paths = [];
     iconText = [];
     navigatorView = [];
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    var json = await SharedPref.getString(key: PrefsValue.accessRight);
    listOFAccessRight = await Accessright.accessrightListFromJson(json);
    listOFAccessRight.sort((a,b) => a.menuCode!.compareTo(b.menuCode!));
    await _tabAccess();
    _eventCompleted(emit);
  }

  _tabAccess(){
    for (var data in listOFAccessRight) {
      if (data.menuCode == "Outage") {
        if (data.navigate == "1") {
        paths.add(AssetPath.navigate);
         iconText.add("Navigate");
         navigatorView.add(NavigateAlertView());
        }
        if (data.add == "1") {
          paths.add(AssetPath.reportOutage);
          iconText.add("Report");
          navigatorView.add(ReportAlertView());
        }
        if (data.manage == "1") {
          paths.add(AssetPath.manage);
          iconText.add("Manage");
          navigatorView.add(ManageAlertView());
        }
      }else{

      }
    }
  }
  _eventCompleted(Emitter<HomeState> emit) {
    emit(FetchHomeDataState(
        isLoader: isLoader,
        scheme: scheme,
        baseUrl: baseUrl,
        userName: userName,
        role: role,
      listOFAccessRight: listOFAccessRight,
       iconText: iconText,
      navigatorView: navigatorView,
      paths: paths,
    ));
  }
}
