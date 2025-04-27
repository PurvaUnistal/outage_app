import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_bloc.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_bloc.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/bloc/manage_alert_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_bloc.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';

MultiBlocProvider multiBlocProvider({required Widget child}) {
  return MultiBlocProvider(providers: [
    BlocProvider(create: (BuildContext context) => LoginBloc()),
    BlocProvider(create: (BuildContext context) => HomeBloc()),
    BlocProvider(create: (BuildContext context) => ManageAlertBloc()),
    BlocProvider(create: (BuildContext context) => CreateAlertFormBloc()),
    BlocProvider(create: (BuildContext context) => MaintenanceAlertBloc()),
    BlocProvider(create: (BuildContext context) => NavigateAlertBloc()),
    BlocProvider(create: (BuildContext context) => ReportAlertBloc()),
    BlocProvider(create: (BuildContext context) => IncidentDetailBloc()),
  ], child: child);
}
