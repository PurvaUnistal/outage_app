import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/bloc/ho_dis_dashboard_bloc.dart';
import 'package:outage_app/features/HoGridDashboard/domain/bloc/ho_grid_dashboard_bloc.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_bloc.dart';
import 'package:outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_bloc.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_bloc.dart';
import 'package:outage_app/features/Manage/IncidentManage/domain/bloc/incident_manage_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_bloc.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_bloc.dart';

MultiBlocProvider multiBlocProvider({required Widget child}) {
  return MultiBlocProvider(providers: [
    BlocProvider(create: (BuildContext context) => LoginBloc()),
    BlocProvider(create: (BuildContext context) => HoDistrictDashboardBloc()),
    BlocProvider(create: (BuildContext context) => HoGridDashboardBloc()),
    BlocProvider(create: (BuildContext context) => InChargeDashboardBloc()),
    BlocProvider(create: (BuildContext context) => IncidentManageBloc()),
    BlocProvider(create: (BuildContext context) => CreateAlertFormBloc()),
    BlocProvider(create: (BuildContext context) => MaintenanceAlertBloc()),
    BlocProvider(create: (BuildContext context) => NavigateAlertBloc()),
    BlocProvider(create: (BuildContext context) => IncidentReportBloc()),
    BlocProvider(create: (BuildContext context) => IncidentDetailBloc()),
  ], child: child);
}
