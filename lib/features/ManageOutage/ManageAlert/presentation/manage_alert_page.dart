import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinKitDancingSquareWidget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/bloc/manage_alert_bloc.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/bloc/manage_alert_event.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/bloc/manage_alert_state.dart';

import 'widget/ViewReportListWidget.dart';

class ManageAlertView extends StatefulWidget {
  const ManageAlertView({super.key});

  @override
  State<ManageAlertView> createState() => _ManageAlertViewState();
}

class _ManageAlertViewState extends State<ManageAlertView>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    BlocProvider.of<ManageAlertBloc>(context)
        .add(ManageAlertLoadEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundInfoWidget(
      child: BlocBuilder<ManageAlertBloc, ManageAlertState>(
        builder: (context, state) {
          if (state is FetchManageAlertDataState) {
            return _itemBuilder(dataState: state);
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
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Manage Alert?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DefaultTabController(
                length: dataState.listOfTab.length,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      tabs: dataState.listOfTab,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Colors.green.shade800,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      onTap: (index) {
                        BlocProvider.of<ManageAlertBloc>(context).add(
                            SelectTabChangedEvent(
                                tabIndex: index, context: context));
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: IndexedStack(
                  index: dataState.tabIndex,
                  children: [
                         ViewReportListWidget(
                           checkIncidentType:dataState.tabIndexLoader,
                            listOfViewIncident: dataState.listOfNewViewIncident,
                          ),
                    ViewReportListWidget(
                      checkIncidentType:dataState.tabIndexLoader,
                            listOfViewIncident:
                                dataState.listOfProgressViewIncident,
                          ),
                   ViewReportListWidget(
                      checkIncidentType:dataState.tabIndexLoader,
                            listOfViewIncident:
                                dataState.listOfCompletedViewIncident,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
