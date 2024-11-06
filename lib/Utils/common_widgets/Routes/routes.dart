import 'package:flutter/material.dart';
import 'package:igl_outage_app/features/Home/presentation/home_view.dart';
import 'package:igl_outage_app/features/Login/presentation/login_view.dart';
import 'package:igl_outage_app/features/MagageOutage/ManageAlert/presentation/manage_alert_page.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/presentation/maintenance_alert_page.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/presentation/report_alert_page.dart';
import 'package:igl_outage_app/features/Splash/presentation/splash_view.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RoutesName.home:
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
