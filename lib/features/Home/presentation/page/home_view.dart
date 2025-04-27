import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/app_update_message_widget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:outage_app/features/Home/presentation/Widgets/phone/phone_home_widget.dart';
import 'package:outage_app/features/Home/presentation/Widgets/tablet_home_widget.dart';
import 'package:outage_app/features/Home/presentation/page/ho_ga_home_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const MethodChannel platform = MethodChannel('agcl/outage');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callMethodeChannel();
    });
    BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent(context: context));
    super.initState();
  }

  callMethodeChannel() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String applicationId = packageInfo.packageName;
      String androidPlayStoreUrl =
          "https://play.google.com/store/apps/details?id=$applicationId&hl=en&gl=US";
      final dynamic result = await platform.invokeMethod('getAppUpdate');
      if (Platform.isAndroid) {
        if (kDebugMode) {
          print("Upgrade Message ============== $result");
        }
        if (result.toString() == "success") {
          try {
            AppUpdateMessage.showAlertDialog(
              context: context,
              url: androidPlayStoreUrl,
              isLater: false,
            );
          } catch (e) {
            AppUpdateMessage.showAlertDialog(
              context: context,
              url: androidPlayStoreUrl,
            );
          }
        }
      }
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            if (AppConfig.instanceInit()?.loginData.user?.isHo == "1") {
              return HoGaHomePage();
            } else {
              return PhoneHomeWidget();
            }
          } else {
            return TabletHomeWidget(); // Tablet Layout
          }
        },
      ),
      //  :const TabletHomeWidget(),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder:
              (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to exit an App?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true),
              ),
        )) ??
        false;
  }
}
