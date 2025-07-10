import 'package:flutter/material.dart';
import 'package:outage_app/features/HoDistrictDashboard/presentation/ho_dis_dashboard_view.dart';
import 'package:outage_app/features/HoGridDashboard/presentation/ho_grid_dashboard_view.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/page/in_charge_dashboard_view.dart';
import 'package:outage_app/features/Login/presentation/page/login_page.dart';
import 'package:outage_app/features/Manage/IncidentManage/presentation/page/incident_manage_view.dart';
import 'package:outage_app/features/Maintenance/MaintenanceAlert/presentation/maintenance_alert_page.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/incident_report_page.dart';
import 'package:outage_app/features/Splash/presentation/splash_view.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashView(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        );
      case RoutesName.disDashboard:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HoDisDashboardView(),
        );
      case RoutesName.gridDashboard:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HoGridDashboardView(),
        );
      case RoutesName.inChargeDashboard:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InChargeDashboardView(),
        );
      case RoutesName.incidentManage:
        return MaterialPageRoute(
          builder: (BuildContext context) => const IncidentManageView(),
        );
      case RoutesName.maintenanceAlertView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const MaintenanceAlertView(),
        );
      case RoutesName.navigateAlertView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const NavigateAlertView(),
        );
      case RoutesName.reportAlertView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const IncidentReportView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
