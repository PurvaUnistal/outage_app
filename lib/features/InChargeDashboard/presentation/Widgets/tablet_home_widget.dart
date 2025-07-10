import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_bloc.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_state.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/card_widget.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/logout_widget.dart';

class TabletInChargeDashboardWidget extends StatefulWidget {
  const TabletInChargeDashboardWidget({super.key});

  @override
  State<TabletInChargeDashboardWidget> createState() => _PhoneInChargeDashboardWidgetState();
}

class _PhoneInChargeDashboardWidgetState extends State<TabletInChargeDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: SafeArea(
        child: BackgroundWidget(
          child: BlocBuilder<InChargeDashboardBloc, InChargeDashboardState>(
            builder: (context, state) {
              if (state is FetchInChargeDashboardDataState) {
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _tabWidget(dataState: state),
                    ));
              } else {
                return const Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }

  _appBarWidget() {
    return AppBarWidget(
      title: "GIS App",
      boolLeading: false,
      actions: [
        IconButton(
            onPressed: () => showModalBottomSheet(
                context: context, builder: (context) => const LogoutWidget()),
            icon: Icon(
              Icons.logout,
              color: AppColor.white,
            ))
      ],
    );
  }

  Widget _tabWidget({required FetchInChargeDashboardDataState dataState}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
            children: [
              _buildCard("MDPE", "${dataState.dashboard.mdpeLength} m",
                  Icons.straighten, Colors.blue.shade100),
              _buildCard("Steel", "${dataState.dashboard.steelLength} m",
                  Icons.construction, Colors.grey.shade300),
              _buildCard("Domestic", "${dataState.dashboard.domesticCount}",
                  Icons.home, Colors.green.shade100),
              _buildCard("Industrial", "${dataState.dashboard.industrialCommercialCount}",
                  Icons.factory, Colors.orange.shade100),
              _buildCard("Pending", "${dataState.dashboard.totalPendingIncident}",
                  Icons.warning, Colors.red.shade100),
              _buildCard("In Progress", "${dataState.dashboard.totalInprogressIncident}",
                  Icons.sync, Colors.yellow.shade100),
              _buildCard("Completed", "${dataState.dashboard.totalCompletedIncident}",
                  Icons.check_circle, Colors.green.shade200),
            ],
          ),

          const SizedBox(height: 24),

          // 📋 Menu Section
          const Text(
            'Modules',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            itemCount: dataState.listOfInChargeData.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final menu = dataState.listOfInChargeData[index];
              final colors = [
                Colors.purple.shade100,
                Colors.teal.shade100,
                Colors.cyan.shade100,
              ];
              final color = colors[index % colors.length];

              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const Icon(Icons.dashboard_customize),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildPermissionChip('Manage', menu.manage == '1'),
                          const SizedBox(width: 4),
                          _buildPermissionChip('Add', menu.add == '1'),
                          const SizedBox(width: 4),
                          _buildPermissionChip('Navigate', menu.navigate == '1'),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              );
            },
          )

        ],
      ),
    );
  }
  Widget _buildPermissionChip(String label, bool granted) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: granted ? Colors.green : Colors.red,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
