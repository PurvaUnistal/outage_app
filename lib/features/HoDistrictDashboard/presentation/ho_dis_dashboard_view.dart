import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/bloc/ho_dis_dashboard_bloc.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/bloc/ho_dis_dashboard_event.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/bloc/ho_dis_dashboard_state.dart';
import 'package:outage_app/features/HoGridDashboard/presentation/ho_grid_dashboard_view.dart';
import 'package:outage_app/features/InChargeDashboard/presentation/Widgets/logout_widget.dart';

import 'widget/summery_card.dart';

class HoDisDashboardView extends StatefulWidget {
  const HoDisDashboardView({super.key});

  @override
  State<HoDisDashboardView> createState() => _HoDisDashboardViewState();
}

class _HoDisDashboardViewState extends State<HoDisDashboardView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HoDistrictDashboardBloc>(
      context,
    ).add(HoDistrictDashboardPageLoadEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<HoDistrictDashboardBloc, HoDistrictDashboardState>(
            builder: (context, state) {
              if (state is FetchHoDistrictDashboardDataState) {
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

  Widget _tabWidget({required FetchHoDistrictDashboardDataState dataState}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2,
              children: [
                SummeryCard(
                  title: 'MDPE',
                  value: '${dataState.dashboard.mdpeLength} km',
                  icon: Icons.straighten,
                  color: Colors.blue.shade100,
                ),
                SummeryCard(
                  title: 'Steel',
                  value: '${dataState.dashboard.steelLength} km',
                  icon: Icons.construction,
                  color: Colors.grey.shade300,
                ),
                SummeryCard(
                  title: 'DPNG',
                  value: '${dataState.dashboard.domesticCount}',
                  icon: Icons.home,
                  color: Colors.green.shade100,
                ),
                SummeryCard(
                  title: 'I & C',
                  value: '${dataState.dashboard.industrialCommercialCount}',
                  icon: Icons.apartment,
                  color: Colors.orange.shade100,
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Districts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListView.separated(
              itemCount: dataState.listOfDistrictData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final location = dataState.listOfDistrictData[index];

                // Color palette
                final colors = [
                  Colors.red.shade100,
                  Colors.green.shade100,
                  Colors.orange.shade100,
                  Colors.blue.shade100,
                  Colors.purple.shade100,
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        (location.name?.isNotEmpty ?? false)
                            ? location.name![0]
                            : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text(
                      location.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      await AppConfig.instanceInit()?.setDistrictData(
                        districtData: location,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HoGridDashboardView(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
