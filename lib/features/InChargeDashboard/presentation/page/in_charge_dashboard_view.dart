import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/app_update_message_widget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_bloc.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_event.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/phone/phone_in_charge_dashboard_widget.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/tablet_home_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InChargeDashboardView extends StatefulWidget {
  const InChargeDashboardView({super.key});

  @override
  State<InChargeDashboardView> createState() => _InChargeDashboardViewState();
}

class _InChargeDashboardViewState extends State<InChargeDashboardView> {
  static const MethodChannel platform = MethodChannel('agcl/outage');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callMethodeChannel();
    });
    BlocProvider.of<InChargeDashboardBloc>(context).add(InChargeDashboardPageLoadEvent(context: context));
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
            return PhoneInChargeDashboardWidget();
          } else {
            return TabletInChargeDashboardWidget(); // Tablet Layout
          }
        },
      ),
      //  :const TabletInChargeDashboardWidget(),
    );
  }

  Future<bool> _onWillPop() async {
    if (AppConfig.instanceInit()?.loginData.user!.gaId == "1") {
      // Directly allow pop
      return true;
    } else {
      return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
          message: "Do you want to exit the App?",
          okButtonText: "Exit",
          onPressed: () => Navigator.of(mContext).pop(true),
        ),
      )) ??
          false;
    }
  }

}
