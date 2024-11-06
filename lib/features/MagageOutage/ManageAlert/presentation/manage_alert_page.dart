import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/MagageOutage/ManageAlert/domain/manage_alert_bloc.dart';
import 'package:igl_outage_app/features/MagageOutage/ManageAlert/domain/manage_alert_event.dart';
import 'package:igl_outage_app/features/MagageOutage/ManageAlert/domain/manage_alert_state.dart';

class ManageAlertView extends StatefulWidget {
  const ManageAlertView({super.key});

  @override
  State<ManageAlertView> createState() => _ManageAlertViewState();
}

class _ManageAlertViewState extends State<ManageAlertView> {
  @override
  void initState() {
    BlocProvider.of<ManageAlertBloc>(context).add(ManageAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundWidget(
        child: BlocBuilder<ManageAlertBloc, ManageAlertState>(
          builder: (context, state) {
            if (state is FetchManageAlertDataState) {
              return  BackgroundWidget(child: _itemBuilder(dataState: state));
            } else {
              return const Center(child: SpinLoader());
            }
          },
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) =>
            MessageBoxTwoButtonPopWidget(message: "Do you want to Manage Alert?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchManageAlertDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.manageAlert,
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
          child: ListView(
            children: [
              CommonStyle.vertical(context: context),
              CommonStyle.vertical(context: context),
              CommonStyle.vertical(context: context),
            ],
          ),
        ),
      ),
    );
  }
}