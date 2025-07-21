import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Background/wavy_background.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoDistrictDashboard/presentation/widget/summery_card.dart';
import 'package:outage_app/features/HoGridDashboard/domain/bloc/ho_grid_dashboard_bloc.dart';
import 'package:outage_app/features/HoGridDashboard/domain/bloc/ho_grid_dashboard_event.dart';
import 'package:outage_app/features/HoGridDashboard/domain/bloc/ho_grid_dashboard_state.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/logout_widget.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/phone/phone_in_charge_dashboard_widget.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/page/in_charge_dashboard_view.dart';

class HoGridDashboardView extends StatefulWidget {
  const HoGridDashboardView({super.key});

  @override
  State<HoGridDashboardView> createState() => _HoGridDashboardViewState();
}

class _HoGridDashboardViewState extends State<HoGridDashboardView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HoGridDashboardBloc>(
      context,
    ).add(HoGridDashboardPageLoadEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<HoGridDashboardBloc, HoGridDashboardState>(
            builder: (context, state) {
              if (state is FetchHoGridDashboardDataState) {
                return _tabWidget(dataState: state);
              } else {
                return Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }

  _appBarWidget() {
    return AppBarWidget(
      title: "AGCL HO",
      boolLeading: true,
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

  Widget _tabWidget({required FetchHoGridDashboardDataState dataState}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisSpacing = 8 * 1;
    final padding = 12;
    final columns = 2;
    final itemWidth = (screenWidth - crossAxisSpacing - padding) / columns;
    final itemHeight = MediaQuery.of(context).size.height * 0.09;

    final aspectRatio = itemWidth / itemHeight;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 6,
              mainAxisSpacing: 4,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final items = [
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
              ];
              return items[index];
            },
          ),
          const SizedBox(height: 20),

          Text(
            'Grids(${AppConfig.instanceInit()?.districtData.name})',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          dataState.listOfGridData.length == 0
              ? Center(
                child: const Text(
                  'No Found Grids',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
                ),
              )
              :ListView.separated(
            itemCount: dataState.listOfGridData.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final grid = dataState.listOfGridData[index];

              final colors = [
                Colors.blue.shade100,
                Colors.green.shade100,
                Colors.orange.shade100,
                Colors.purple.shade100,
                Colors.teal.shade100,
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
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      grid.gridName?.substring(0, 1) ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    grid.gridName ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    await AppConfig.instanceInit()?.setGridData(
                      gridData: grid,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InChargeDashboardView(),
                      ),
                    );
                  },
                ),
              );
            },
          ),

        ],
      ),
    );
  }

}
