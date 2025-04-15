import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Loader/WaveLoaderWidget.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_event.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_state.dart';
import '../../../../Utils/common_widgets/res/app_string.dart';
import 'widget/legend_widget.dart';

class ReportAlertView extends StatefulWidget {
  const ReportAlertView({super.key});

  @override
  State<ReportAlertView> createState() => _ReportAlertViewState();
}

class _ReportAlertViewState extends State<ReportAlertView> {
  @override
  void initState() {
    BlocProvider.of<ReportAlertBloc>(context)
        .add(ReportAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.reportAlert,
        boolLeading: true,
      ),
      body: BackgroundInfoWidget(
        child: BlocBuilder<ReportAlertBloc, ReportAlertState>(
          builder: (context, state) {
            if (state is FetchReportAlertDataState) {
              return _itemBuilder(dataState: state);
            } else {
              return const Center(child: SpinLoader());
            }
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Report Alert?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchReportAlertDataState dataState}) {
    return Stack(children: <Widget>[
      _googleMapWidget(dataState: dataState),
      dataState.isPipelineLoader == false
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    _mapTypeButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _legendButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _currentLocationButtonWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _filterButtonWidget(dataState: dataState),
                  ],
                ),
              ),
            )
          : WaveLoaderWidget(),
    ]);
  }

  _googleMapWidget({required FetchReportAlertDataState dataState}) {
    return GoogleMap(
      mapType: dataState.currentMapType,
      compassEnabled: true,
      myLocationEnabled: true,
      circles: dataState.circles,
      markers: dataState.markersPointList,
      polylines: dataState.polylinePointList,
      initialCameraPosition: dataState.cameraPosition,
      onMapCreated: (GoogleMapController controller) {
        dataState.googleMapController.complete(controller);
      },
      minMaxZoomPreference: MinMaxZoomPreference(15, 18),
      onCameraIdle: () {
        BlocProvider.of<ReportAlertBloc>(context).add(OnCameraIdleEvent(
          context: context,
        ));
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
            ? BlocProvider.of<ReportAlertBloc>(context).add(
                SelectGoogleMapButtonEvent(
                    context: context, latLngOnTap: latLng))
            : (latLng) {};
      },
    );
  }

  _mapTypeButtonWidget({required FetchReportAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () => BlocProvider.of<ReportAlertBloc>(context)
          .add(SelectMapTypeButtonEvent()),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.layers,
        size: 21.0,
        color: AppColor.white,
      ),
    );
  }

  _currentLocationButtonWidget({required FetchReportAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () => BlocProvider.of<ReportAlertBloc>(context)
          .add(SelectCurrentMarkerButtonEvent(context: context)),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.my_location_rounded,
        size: 21.0,
        color: AppColor.white,
      ),
    );
  }

  _filterButtonWidget({required FetchReportAlertDataState dataState}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
      child: Icon(
        Icons.filter_alt,
        size: 21.0,
        color: AppColor.white,
      ),
      onPressed: () => BlocProvider.of<ReportAlertBloc>(context)
          .add(SelectFilterButtonEvent(context: context)),
    );
  }

  Widget _legendButtonWidget({required FetchReportAlertDataState dataState}) {
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
}
