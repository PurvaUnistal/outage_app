import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/background_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:outage_app/features/Home/domain/bloc/home_state.dart';
import 'package:outage_app/features/Home/presentation/Widgets/card_widget.dart';
import 'package:outage_app/features/Home/presentation/Widgets/logout_widget.dart';

class TabletHomeWidget extends StatefulWidget {
  const TabletHomeWidget({super.key});

  @override
  State<TabletHomeWidget> createState() => _PhoneHomeWidgetState();
}

class _PhoneHomeWidgetState extends State<TabletHomeWidget> {
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
      title: RoutesName.outageApp,
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

  Widget _tabWidget({required FetchHomeDataState dataState}) {
    return GridView.builder(
      itemCount: dataState.paths.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dataState.navigatorView[index])),
          child: CardWidget(
            text: dataState.iconText[index],
            path: dataState.paths[index],
          ),
        );
      },
    );
  }
}
