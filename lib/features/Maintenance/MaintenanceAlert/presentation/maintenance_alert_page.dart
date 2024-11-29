import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_bloc.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_event.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_state.dart';

class MaintenanceAlertView extends StatefulWidget {
  const MaintenanceAlertView({super.key});

  @override
  State<MaintenanceAlertView> createState() => _MaintenanceAlertViewState();
}

class _MaintenanceAlertViewState extends State<MaintenanceAlertView> {
  @override
  void initState() {
    BlocProvider.of<MaintenanceAlertBloc>(context).add(MaintenanceAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundInfoWidget(
      child: BlocBuilder<MaintenanceAlertBloc, MaintenanceAlertState>(
        builder: (context, state) {
          if (state is FetchMaintenanceAlertDataState) {
            return  _itemBuilder(dataState: state);
          } else {
            return const Center(child: SpinLoader());
          }
        },
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) =>
            MessageBoxTwoButtonPopWidget(message: "Do you want to Maintenance Alert?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchMaintenanceAlertDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.maintenanceAlert,
          boolLeading: true,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataState.userName,
                  textAlign: TextAlign.start,
                  style: Styles.rel,
                ),
                Text(
                  dataState.scheme,
                  textAlign: TextAlign.start,
                  style: Styles.rel,
                )
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
          child: Center(
            child: Text("No data founds", style: Styles.labels,),
          )
        ),
      ),
    );
  }
}