import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_bloc.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_event.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_state.dart';

class FullGoogleMapWidget extends StatelessWidget {
  const FullGoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Report", boolLeading: true),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: BlocBuilder<IncidentDetailBloc, IncidentDetailState>(
            builder: (context, state) {
              if (state is FetchIncidentDetailDataState) {
                return _itemBuilder(dataState: state,context: context);
              } else {
                return const Center(child: SpinLoader());
              }
            },
          ),
        ),
      ),
    );
  }

  _itemBuilder({required FetchIncidentDetailDataState dataState,required BuildContext context}) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            buildingsEnabled: false,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: true,
            minMaxZoomPreference: _getZoomPreference(dataState),
            initialCameraPosition: CameraPosition(
              target: dataState.incidentLocation,
              zoom: AppString.zoom,
            ),
            markers: Set<Marker>.of(dataState.markersPointList),
            polylines: dataState.polylinePointList,
            onCameraIdle: () {
              BlocProvider.of<IncidentDetailBloc>(
                context,
              ).add(IncidentDetailOnCameraIdleEvent(context: context));
            },
            onMapCreated: (GoogleMapController controller) {
              if (!dataState.googleMapController.isCompleted) {
                dataState.googleMapController.complete(controller);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                ),
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.fullscreen_exit_rounded,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MinMaxZoomPreference _getZoomPreference(FetchIncidentDetailDataState state) {
    return state.polylinePointList.length >= 2000
        ? const MinMaxZoomPreference(15, null)
        : const MinMaxZoomPreference(17, null);
  }
}
