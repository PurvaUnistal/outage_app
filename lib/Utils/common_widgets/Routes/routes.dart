import 'package:flutter/material.dart';
import 'package:outage_app/features/Home/presentation/page/ho_ga_home_view.dart';
import 'package:outage_app/features/Home/presentation/page/home_view.dart';
import 'package:outage_app/features/Login/presentation/page/login_page.dart';
import 'package:outage_app/features/Manage/ManageAlert/presentation/page/manage_alert_page.dart';
import 'package:outage_app/features/Maintenance/MaintenanceAlert/presentation/maintenance_alert_page.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/presentation/report_alert_page.dart';
import 'package:outage_app/features/Splash/presentation/splash_view.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case RoutesName.hogaHome:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HoGaHomePage());
      case RoutesName.gisApp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
      case RoutesName.manageAlertView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ManageAlertView());
      case RoutesName.maintenanceAlertView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MaintenanceAlertView());
      case RoutesName.navigateAlertView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NavigateAlertView());
      case RoutesName.reportAlertView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReportAlertView());
        default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
