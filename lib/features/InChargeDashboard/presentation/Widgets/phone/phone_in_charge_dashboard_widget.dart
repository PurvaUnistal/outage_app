import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/features/HoDistrictDashboard/presentation/widget/summery_card.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_bloc.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_state.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/card_widget.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/logout_widget.dart';
import 'package:outage_app/features/Manage/IncidentManage/presentation/page/incident_manage_view.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/incident_report_page.dart';

class PhoneInChargeDashboardWidget extends StatefulWidget {
  const PhoneInChargeDashboardWidget({super.key});

  @override
  State<PhoneInChargeDashboardWidget> createState() =>
      _PhoneInChargeDashboardWidgetState();
}

class _PhoneInChargeDashboardWidgetState
    extends State<PhoneInChargeDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<InChargeDashboardBloc, InChargeDashboardState>(
            builder: (context, state) {
              if (state is FetchInChargeDashboardDataState) {
                return _tabWidget(dataState: state);
              } else {
                return const Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }

  AppBarWidget _appBarWidget() {
    return AppBarWidget(
   //   title: "GIS App",
      boolLeading:
          AppConfig.instanceInit()?.loginData.user!.isHo == "1" ? true : false,
      actions: [
        IconButton(
          onPressed:
              () => showModalBottomSheet(
                context: context,
                builder: (context) => const LogoutWidget(),
              ),
          icon: Icon(Icons.logout, color: AppColor.white),
        ),
      ],
    );
  }

  Widget _tabWidget({required FetchInChargeDashboardDataState dataState}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio:  2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              SummeryCard(
                title: "MDPE",
                value: "${dataState.dashboard.mdpeLength} km",
                icon: Icons.straighten,
                color: Colors.blue.shade100,
              ),
              SummeryCard(
                title: "Steel",
                value: "${dataState.dashboard.steelLength} km",
                icon: Icons.construction,
                color: Colors.grey.shade300,
              ),
              SummeryCard(
                title: "DPNG",
                value: "${dataState.dashboard.domesticCount}",
                icon: Icons.home,
                color: Colors.green.shade100,
              ),
              SummeryCard(
                title: "I & C",
                value: "${dataState.dashboard.industrialCommercialCount}",
                icon: Icons.factory,
                color: Colors.orange.shade100,
              ),

            ],
          ),
         CommonStyle.vertical(context: context),
          GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              IncidentCard(
                title: "Incident New",
                value: "${dataState.dashboard.totalPendingIncident}",
                icon: Icons.warning,
                color: Colors.red.shade100,
              ),
              IncidentCard(
                title: "Incident In Progress",
                value: "${dataState.dashboard.totalInprogressIncident}",
                icon: Icons.sync,
                color: Colors.yellow.shade100,
              ),
              IncidentCard(
                title: "Incident Completed",
                value: "${dataState.dashboard.totalCompletedIncident}",
                icon: Icons.check_circle,
                color: Colors.green.shade200,
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Modules',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          dataState.listOfInChargeData.isEmpty
              ? const Center(
                child: Text(
                  'No Modules Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              )
              : GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
            childAspectRatio: 1.05,
                children:
                    dataState.listOfInChargeData
                        .expand(
                          (menu) => [
                            if (menu.navigate == '1')
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavigateAlertView(),
                                    ),
                                  ); },
                                child: CardWidget(
                                  text: 'Navigate',
                                  path: AssetPath.navigate,
                                ),
                              ),
                            if (menu.add == '1')
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IncidentReportView(),
                                    ),
                                  );

                               },
                                child: CardWidget(
                                  text: 'Incident Reports',
                                  path: AssetPath.reportOutage,
                                ),
                              ),
                            if (menu.manage == '1')
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IncidentManageView(),
                                    ),
                                  );
                                },
                                child: CardWidget(
                                  text: 'Incident Manage',
                                  path: AssetPath.manage,
                                ),
                              ),
                          ],
                        )
                        .toList(),
              ),
        ],
      ),
    );
  }

}
