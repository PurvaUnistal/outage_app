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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamically change columns based on screen width
    final columns = screenWidth >= 900
        ? 4
        : screenWidth >= 600
        ? 3
        : 2;

    final padding = screenWidth * 0.04;
    final crossAxisSpacing = screenWidth * 0.03;
    final mainAxisSpacing = screenHeight * 0.015;
    final itemHeight = screenHeight * 0.12;
    final itemWidth = (screenWidth - (columns - 1) * crossAxisSpacing - padding) / columns;
    final aspectRatio = itemWidth / itemHeight;

  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
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
          SizedBox(height: screenHeight * 0.03),

          Text(
            'Districts',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          ListView.separated(
            itemCount: dataState.listOfDistrictData.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.015),
            itemBuilder: (context, index) {
              final location = dataState.listOfDistrictData[index];

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
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      (location.name?.isNotEmpty ?? false)
                          ? location.name![0]
                          : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    location.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.035),
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
