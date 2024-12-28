import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/commonClass/app_config.dart';
import 'package:igl_outage_app/Utils/commonClass/enums.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_bloc.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:igl_outage_app/features/Home/presentation/Widgets/phone/phone_home_widget.dart';
import 'package:igl_outage_app/features/Home/presentation/Widgets/tablet_home_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child:
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return PhoneHomeWidget(); // Phone Layout
        } else {
          return TabletHomeWidget(); // Tablet Layout
        }
           }
         )
        //  :const TabletHomeWidget(),
    );

  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "Do you want to exit an App?",
            okButtonText: "Exit",
            onPressed: () =>  Navigator.of(context).pop(true)
        ))
    ) ?? false;
  }
  }
