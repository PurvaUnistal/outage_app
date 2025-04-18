import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    _getData();
    toLogin();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  Future<void> toLogin() async {
    final email = await SharedPref.getString(key: PrefsValue.emailVal);
    final password = await SharedPref.getString(key: PrefsValue.passwordVal);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final newVersion  = await packageInfo.buildNumber;
    AppConfig.instanceInit()?.setAppVersion(appVersion: packageInfo.buildNumber);
    final oldVersion = await SharedPref.getString(key: PrefsValue.buildNumber);
    Timer(
        const Duration(seconds: 3),
    () async {
      if (oldVersion == newVersion) {
        if (email.isNotEmpty || password.isNotEmpty) {
       //   Navigator.push(context, (MaterialPageRoute(builder: (context) => DynamicPolylineMap(),)));
          Navigator.pushReplacementNamed(
            context,
            RoutesName.outageApp,
          );
        }
      } else {
        await SharedPref.clearAll();
        Navigator.pushReplacementNamed(
          context,
          RoutesName.login,
        );
      }
    });
  }

  Future<LoginModel?> _getData() async {
    try {
      String? userJson = await SharedPref.getString(key: PrefsValue.userInfo ?? "");
      if (userJson != '') {
        Map<String, dynamic> userMap = jsonDecode(userJson!);
        LoginModel loginModel = LoginModel.fromJson(userMap);
        final appConfig = AppConfig.instanceInit();
        if (appConfig != null) {
          await appConfig.setLoginData(newLoginData: loginModel);
        }
        return loginModel;
      }
    } catch (e) {
      debugPrint("Error in _getData: $e");
    }
    return null;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AppConfig.instanceInit()!.client == Client.agcl
                    ? AssetPath.agclLogo
                    : AppConfig.instanceInit()!.client == Client.purvaBharti
                        ? AssetPath.pbgLogo
                        : AssetPath.iglLogo,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
          ),
        ));
  }
}
