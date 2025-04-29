import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Background/wavy_background.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_widget.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:outage_app/features/Home/domain/bloc/home_state.dart';
import 'package:outage_app/features/Home/presentation/Widgets/logout_widget.dart';
import 'package:outage_app/features/Home/presentation/Widgets/phone/phone_home_widget.dart';

class HoGaHomePage extends StatefulWidget {
  const HoGaHomePage({super.key});

  @override
  State<HoGaHomePage> createState() => _HoGaHomePageState();
}


class _HoGaHomePageState extends State<HoGaHomePage> {

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent(context: context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: SafeArea(
        child: BackgroundWidget(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchHomeDataState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _tabWidget(dataState: state),
                  ),
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

  _appBarWidget() {
    return AppBarWidget(
      title: "HO Dashboard",
      boolLeading: false,
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



  Widget _tabWidget({required FetchHomeDataState dataState}) {
    return GridView.builder(
      itemCount: dataState.listOfHOG.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        final item = dataState.listOfHOG[index];

        return InkWell(
          onTap: () async {
            await AppConfig.instanceInit()?.setGaId(gaId: item.id!);
            await AppConfig.instanceInit()?.setHoSchema(hoSchema: item.schema!);
            await LogoutWidget.clearAndClosePipelineBox();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhoneHomeWidget()),
            );

          },
          child: Card(
            elevation: 12,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Background wave using ClipPath
                ClipPath(
                  clipper: TopWaveClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors:  [Color(0xFF1775D6), Colors.white],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),

                // Foreground content
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "${item.name} (${item.id})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
