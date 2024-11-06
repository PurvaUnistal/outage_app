import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';

class NavigateAlertView extends StatefulWidget {
  const NavigateAlertView({super.key});

  @override
  State<NavigateAlertView> createState() => _NavigateAlertViewState();
}

class _NavigateAlertViewState extends State<NavigateAlertView> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  void initState() {
    BlocProvider.of<NavigateAlertBloc>(context).add(NavigateAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
        builder: (context, state) {
          if (state is FetchNavigateAlertDataState) {
            return BackgroundWidget(child: _itemBuilder(dataState: state));
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
        builder: (BuildContext mContext) =>
            MessageBoxTwoButtonPopWidget(message: "Do you want to Navigate Alert?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }
  Widget _itemBuilder({required FetchNavigateAlertDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.navigateAlert,
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
        body:Stack(
            children: <Widget>[
              _googleMapWidget(dataState:dataState),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      _mapTypeButtonWidget(dataState: dataState),
                      SizedBox(height: 16.0),
                      _addLocationButtonWidget(dataState: dataState),
                    ],
                  ),

                ),
              ),
        ]
        )
      ),
    );
  }
  _googleMapWidget({required FetchNavigateAlertDataState dataState}){
    return GoogleMap(
      mapType: dataState.currentMapType,
      markers: dataState.markers,
      onCameraMove: (CameraPosition cameraPosition){
        BlocProvider.of<NavigateAlertBloc>(context).add(SelectAddMarkerButtonEvent());
      },
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }
  _mapTypeButtonWidget({required FetchNavigateAlertDataState dataState}){
    return  FloatingActionButton(
      onPressed: () {
        BlocProvider.of<NavigateAlertBloc>(context).add(SelectMapTypeButtonEvent());
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor:  AppColor.primer,
      child: Icon(Icons.map, size: 36.0, color: AppColor.white,),
    );
  }
  _addLocationButtonWidget({required FetchNavigateAlertDataState dataState}){
    return  FloatingActionButton(
      onPressed: () {
        BlocProvider.of<NavigateAlertBloc>(context).add(SelectAddMarkerButtonEvent());
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: AppColor.primer,
      child: Icon(Icons.add_location, size: 36.0, color: AppColor.white,),
    );
  }
}