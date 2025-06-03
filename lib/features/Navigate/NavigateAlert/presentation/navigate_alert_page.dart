import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:outage_app/features/Report/ReportOutageAlert/presentation/widget/legend_widget.dart';

class NavigateAlertView extends StatefulWidget {
  const NavigateAlertView({super.key});

  @override
  State<NavigateAlertView> createState() => _NavigateAlertViewState();
}

class _NavigateAlertViewState extends State<NavigateAlertView> {
  @override
  void initState() {
    BlocProvider.of<NavigateAlertBloc>(context)
        .add(NavigateAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.navigateAlert,
        boolLeading: true,
      ),
      body: BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
        builder: (context, state) {
          if (state is FetchNavigateAlertDataState) {
            return _itemBuilder(dataState: state);
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
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Report Incident?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchNavigateAlertDataState dataState}) {
    return Stack(children: <Widget>[
       _googleMapWidget(dataState: dataState),
       dataState.isPipelineLoader == false
           ? Align(
             alignment: Alignment.topRight,
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [  CommonStyle.vertical(context: context),
                /*   _startLocationWidget(dataState: dataState),
                   CommonStyle.vertical(context: context),
                   _destinationLocationWidget(dataState: dataState),
                   CommonStyle.vertical(context: context),*/
                   _mapTypeButtonWidget(dataState: dataState),
                   SizedBox(height: 16.0),
                   _legendButtonWidget(dataState: dataState),
                   SizedBox(height: 16.0),
                   _currentLocationButtonWidget(dataState: dataState),
                   SizedBox(height: 16.0),
                   _filterButtonWidget(dataState: dataState),
                   Spacer(),
                   _routeDirButtonWidget(dataState: dataState),
                   Spacer(),
                 ],
               ),
             ),
           )
           : WaveLoaderWidget(),
     ]);
  }



  Widget _googleMapWidget({required FetchNavigateAlertDataState dataState}) {
    return GoogleMap(
      mapType: dataState.currentMapType,
    //  myLocationEnabled: true,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: true,

      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: dataState.markersPointList,
      polylines: dataState.polylinePointList,
      initialCameraPosition: dataState.position,
      onMapCreated: (GoogleMapController controller) {
        if (! dataState.googleMapController.isCompleted) {
          dataState.googleMapController.complete(controller);

        }
      },
      minMaxZoomPreference: MinMaxZoomPreference(15, null),
      onCameraIdle: () {
        BlocProvider.of<NavigateAlertBloc>(context).add(NavigateAlertOnCameraIdleEvent(
          context: context,
        ));
      },
      onTap: (latLng) async {
        GoogleMapController controller = await dataState.googleMapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: AppString.zoom),
          ),
        );
        dataState.polylinePointList.isNotEmpty ?
        BlocProvider.of<NavigateAlertBloc>(context).add(
            SelectGoogleMapButtonEvent(
                context: context, latLngOnTap: latLng))
            : (latLng) {};
      },
    );
  }



  Widget _destinationLocationWidget(
      {required FetchNavigateAlertDataState dataState}) {
    return TextFieldWidget(
      label: "Destination",
      hintText: "Destination",
      // suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.my_location)),
      //  controller:dataState.addressController
    );
  }

  Widget _mapTypeButtonWidget(
      {required FetchNavigateAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () => BlocProvider.of<NavigateAlertBloc>(context)
          .add(SelectMapTypeButtonEvent()),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.layers,
        size: 21.0,
        color: AppColor.white,
      ),
    );
  }

  Widget _currentLocationButtonWidget(
      {required FetchNavigateAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () => BlocProvider.of<NavigateAlertBloc>(context)
          .add(SelectCurrentMarkerButtonEvent(context:context)),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.my_location_rounded,
        size: 21.0,
        color: AppColor.white,
      ),
    );
  }

  Widget _legendButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.info_outline,
        size: 21.0,
        color: AppColor.white,
      ),
      onPressed: () async {
        await showDialog(
        context: context,
        builder: (BuildContext context) {
          return LegendPopWidget(
              mContext: context,
            );
        });
      },
    );
  }

  Widget _filterButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.filter_alt,
        size: 21.0,
        color: AppColor.white,
      ),
      onPressed: () => BlocProvider.of<NavigateAlertBloc>(context)
          .add(SelectFilterButtonEvent(context: context)),
    );
  }

  Widget _routeDirButtonWidget({required FetchNavigateAlertDataState dataState}) {
    return dataState.isMapDir == true ? Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
        child: Icon(
          Icons.alt_route,
          size: 21.0,
          color: AppColor.white,
        ),
        shape: CircleBorder(),
        onPressed: () {
          BlocProvider.of<NavigateAlertBloc>(context).add(
              SelectGoogleRouteDirEvent(
                  context: context,));
        },
      ),
    ): Container();
  }
}
