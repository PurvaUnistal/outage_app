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
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_bloc.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_event.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_state.dart';

import 'widget/circle_button.dart';
import 'widget/legend_widget.dart';
import 'widget/search_destination.dart';

class IncidentReportView extends StatefulWidget {
  const IncidentReportView({super.key});

  @override
  State<IncidentReportView> createState() => _IncidentReportViewState();
}

class _IncidentReportViewState extends State<IncidentReportView> {
  double _bearing = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentReportBloc>(
      context,
    ).add(IncidentReportLoadEvent(context: context));
    BlocProvider.of<IncidentReportBloc>(
      context,
    ).add(OnCameraIdleEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.incidentReport, boolLeading: true),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<IncidentReportBloc, IncidentReportState>(
            builder: (context, state) {
              if (state is FetchIncidentReportDataState) {
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

  Widget _itemBuilder({required FetchIncidentReportDataState dataState}) {
    return Stack(
      children: <Widget>[
        _googleMapWidget(dataState: dataState),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Visibility(
            visible: dataState.isVisible,
            child: SearchDestination(),
          ),
        ),
        dataState.isPipelineLoader
            ? const WaveLoaderWidget()
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
                    SizedBox(height: 16.0),
                    _searchButtonWidget(dataState: dataState),
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

  _googleMapWidget({required FetchIncidentReportDataState dataState}) {
    return GoogleMap(
      buildingsEnabled: false,
      mapType: dataState.currentMapType,
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: true,
      buildingsEnabled: false,
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
        BlocProvider.of<IncidentReportBloc>(
          context,
        ).add(OnCameraIdleEvent(context: context));
      },
      onTap: (latLng) async {
        GoogleMapController controller =
            await dataState.googleMapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 19),
          ),
        );
        dataState.polylinePointList.isNotEmpty
            ? BlocProvider.of<IncidentReportBloc>(context).add(
              SelectGoogleMapButtonEvent(context: context, latLngOnTap: latLng),
            )
            : (latLng) {};
      },
    );
  }

  MinMaxZoomPreference _getZoomPreference(FetchIncidentReportDataState state) {
    return state.polylinePointList.length >= 2000
        ? const MinMaxZoomPreference(15, null)
        : const MinMaxZoomPreference(17, null);
  }

  _mapTypeButtonWidget({required FetchIncidentReportDataState dataState}) {
    return CircleButton(
      onTap:
          () => BlocProvider.of<IncidentReportBloc>(
            context,
          ).add(SelectMapTypeButtonEvent()),
      iconData: Icons.layers,
    );
  }

  Widget _legendButtonWidget({
    required FetchIncidentReportDataState dataState,
  }) {
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
    required FetchIncidentReportDataState dataState,
  }) {
    return CircleButton(
      iconData: Icons.my_location_rounded,
      onTap:
          () => BlocProvider.of<IncidentReportBloc>(
            context,
          ).add(CurrentLocationEvent()),
    );
  }

  _filterButtonWidget({required FetchIncidentReportDataState dataState}) {
    return CircleButton(
      iconData: Icons.filter_alt,
      onTap:
          () => BlocProvider.of<IncidentReportBloc>(
            context,
          ).add(SelectFilterButtonEvent(context: context)),
    );
  }

  _emergencyButtonWidget({required FetchIncidentReportDataState dataState}) {
    return CircleButton(
      iconData: Icons.emergency_outlined,
      onTap:
          () => BlocProvider.of<IncidentReportBloc>(
            context,
          ).add(SelectEmergencyEvent(context: context)),
    );
  }

  _searchButtonWidget({required FetchIncidentReportDataState dataState}) {
    return CircleButton(
      iconData: Icons.search,
      onTap:
          () => BlocProvider.of<IncidentReportBloc>(
            context,
          ).add(SearchHideShowEvent()),
    );
  }

  Widget _routeDirButtonWidget({
    required FetchIncidentReportDataState dataState,
  }) {
    return dataState.isMapDir == true
        ? FloatingActionButton(
          heroTag: UniqueKey(),
          backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
          child: Icon(Icons.alt_route, size: 21.0, color: AppColor.white),
          shape: CircleBorder(),
          onPressed: () {
            BlocProvider.of<IncidentReportBloc>(
              context,
            ).add(SelectGoogleRouteDirEvent(context: context));
          },
        )
        : Container();
  }
}
