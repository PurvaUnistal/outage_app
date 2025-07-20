import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Loader/WaveLoaderWidget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/circle_button.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/legend_widget.dart';

class NavigateAlertView extends StatefulWidget {
  const NavigateAlertView({super.key});

  @override
  State<NavigateAlertView> createState() => _NavigateAlertViewState();
}

class _NavigateAlertViewState extends State<NavigateAlertView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NavigateAlertBloc>(
      context,
    ).add(NavigateAlertLoadEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.navigateAlert, boolLeading: true),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
            builder: (context, state) {
              if (state is FetchNavigateAlertDataState) {
                return _itemBuilder(dataState: state);
              } else {
                return const Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder:
              (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Report Incident?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true),
              ),
        )) ??
        false;
  }

  Widget _itemBuilder({required FetchNavigateAlertDataState dataState}) {
    return Stack(
      children: <Widget>[
        _googleMapWidget(dataState: dataState),
        dataState.isPipelineLoader
            ? WaveLoaderWidget()
            : Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommonStyle.vertical(context: context),
                    _currentLocationButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _legendButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _mapTypeButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _filterButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _emergencyButtonWidget(dataState: dataState),
                    // SizedBox(height: 16.0),
                    // _searchButtonWidget(dataState: dataState),
                    Spacer(),
                    _routeDirButtonWidget(dataState: dataState),
                    Spacer(),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _googleMapWidget({required FetchNavigateAlertDataState dataState}) {
    return GoogleMap(
      buildingsEnabled: false,
      mapType: dataState.currentMapType,
      rotateGesturesEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: true,

      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: dataState.markersPointList,
      polylines: dataState.polylinePointList,
      initialCameraPosition: CameraPosition(target: dataState.currentPosition),

      onMapCreated: (GoogleMapController controller) {
        if (!dataState.googleMapController.isCompleted) {
          dataState.googleMapController.complete(controller);
        }
      },
      minMaxZoomPreference: _getZoomPreference(dataState),

      // minMaxZoomPreference: MinMaxZoomPreference(15, null),
      onCameraIdle: () {
        BlocProvider.of<NavigateAlertBloc>(
          context,
        ).add(NavigateAlertOnCameraIdleEvent(context: context));
      },
      onTap: (latLng) async {
        final controller = await dataState.googleMapController.future;

        // animate camera to tap position
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: AppString.zoom),
          ),
        );

        // notify bloc if polylines exist
        if (dataState.polylinePointList.isNotEmpty) {
          BlocProvider.of<NavigateAlertBloc>(context).add(
            SelectGoogleMapButtonEvent(context: context, latLngOnTap: latLng),
          );
        }
      },
    );
  }

  MinMaxZoomPreference _getZoomPreference(FetchNavigateAlertDataState state) {
    return state.polylinePointList.length >= 2000
        ? const MinMaxZoomPreference(15, null)
        : const MinMaxZoomPreference(17, null);
  }

  Widget _destinationLocationWidget({
    required FetchNavigateAlertDataState dataState,
  }) {
    return TextFieldWidget(
      label: "Destination",
      hintText: "Destination",
      // suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.my_location)),
      //  controller:dataState.addressController
    );
  }

  _mapTypeButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return CircleButton(
      onTap:
          () => BlocProvider.of<NavigateAlertBloc>(
            context,
          ).add(SelectMapTypeButtonEvent()),
      iconData: Icons.layers,
    );
  }

  Widget _legendButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return CircleButton(
      iconData: Icons.info_outline,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return LegendPopWidget(context: context);
          },
        );
      },
    );
  }

  _currentLocationButtonWidget({
    required FetchNavigateAlertDataState dataState,
  }) {
    return CircleButton(
      iconData: Icons.my_location_rounded,
      onTap:
          () => BlocProvider.of<NavigateAlertBloc>(
            context,
          ).add(UpdateStartAddress()),
    );
  }

  _filterButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return CircleButton(
      iconData: Icons.filter_alt,
      onTap:
          () => BlocProvider.of<NavigateAlertBloc>(
            context,
          ).add(SelectFilterButtonEvent(context: context)),
    );
  }

  _emergencyButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return CircleButton(
      iconData: Icons.emergency_outlined,
      onTap:
          () => BlocProvider.of<NavigateAlertBloc>(
            context,
          ).add(SelectEmergencyEvent(context: context)),
    );
  }

  bool isSearchDestination = false;

  _searchButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return CircleButton(
      iconData: Icons.search,
      onTap: () {
        setState(() {
          isSearchDestination = true;
        });
      },
    );
  }

  Widget _routeDirButtonWidget({
    required FetchNavigateAlertDataState dataState,
  }) {
    return dataState.isMapDir == true
        ? FloatingActionButton(
          heroTag: UniqueKey(),
          backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
          child: Icon(Icons.alt_route, size: 21.0, color: AppColor.white),
          shape: CircleBorder(),
          onPressed: () {
            BlocProvider.of<NavigateAlertBloc>(
              context,
            ).add(SelectGoogleRouteDirEvent(context: context));
          },
        )
        : Container();
  }
}
