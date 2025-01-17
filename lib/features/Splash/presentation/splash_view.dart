import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';

import 'CustomDialogWidget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    toLogin();
    checkForForceUpgrade(context: context);
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
    String email = await SharedPref.getString(key: PrefsValue.emailVal);
    String password = await SharedPref.getString(key: PrefsValue.passwordVal);
    String newVersion = await ForceUpgradeDialog.getCurrentAppVersion();
    String oldVersion = await SharedPref.getString(key: PrefsValue.appVersion);
    print("newVersion--${newVersion}");
    print("oldVersion--${oldVersion}");
    Timer(
      const Duration(seconds: 3),
      () async {
        if (oldVersion == newVersion) {
          if (email.isNotEmpty || password.isNotEmpty) {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.outageApp,
            );
          }
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.login,
          );
        }
      },
    );
  }

  checkForForceUpgrade({required BuildContext context}) async {
    String newVersion = await ForceUpgradeDialog.getCurrentAppVersion();
    String oldVersion = await SharedPref.getString(key: PrefsValue.appVersion);
    final appStoreUrl = "";
    if (ForceUpgradeDialog.isUpdateRequired(
      currentVersion: oldVersion,
      latestVersion: newVersion,
    )) {
      ForceUpgradeDialog.showForceUpgradeDialog(
          context: context, appStoreUrl: appStoreUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: FutureBuilder(
          future: checkForForceUpgrade(context: context),
          builder: (context, snapshot) {
            return Center(
              child: ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AssetPath.agclLogo,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
