import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_state.dart';
import 'package:igl_outage_app/features/MagageOutage/ManageAlert/presentation/manage_alert_page.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/presentation/maintenance_alert_page.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/presentation/navigate_alert_page.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/presentation/report_alert_page.dart';
import 'Widgets/card_widget.dart';
import 'Widgets/logout_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

List<String> paths = [
  AssetPath.manage,
  AssetPath.maintenance,
  AssetPath.navigate,
  AssetPath.reportOutage,
];

List<String> iconText = [
  "Navigate",
  "Report",
  "Manage",
  "Maintenance",
];

List<Widget> navigatorView = [
  NavigateAlertView(),
  ReportAlertView(),
  ManageAlertView(),
  MaintenanceAlertView(),

];

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: RoutesName.home,
        boolLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => const LogoutWidget());
              },
              icon: Icon(
                Icons.logout,
                color: AppColor.white,
              ))
        ],
      ),
      body: SafeArea(
        child: BackgroundWidget(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchHomeDataState) {
                return Center(
                    child:Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child:  _buildLayout(dataState: state),
                    )

                );
              } else {
                return const Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }
  _buildLayout({required FetchHomeDataState dataState}){
    return Container(
        padding: EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: paths.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => navigatorView[index]));
              },
              child: CardWidget(
                text: iconText[index],
                path: paths[index],
              ),
            );
          },
        ));
  }
  }

