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
  final Set<Polyline> polylineList;
  final Set<Marker> markerList;
  final LatLng cameraLatLng;

  const FullGoogleMapWidget({
    super.key,
    required this.polylineList,
    required this.markerList,
    required this.cameraLatLng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Report", boolLeading: true),
      body: SafeArea(
        child: BackgroundInfoWidget(
          child: Stack(
            children: [
              GoogleMap(
                polylines: polylineList,
                markers: markerList,
                initialCameraPosition: CameraPosition(
                  target: cameraLatLng,
                  zoom: 16,
                ),
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
                onMapCreated: (controller) {},
                onCameraIdle: () {
                  BlocProvider.of<IncidentDetailBloc>(context).add(IncidentDetailOnCameraIdleEvent(
                    context: context,
                  ));
                },
                minMaxZoomPreference: _getZoomPreference(polylineList.length),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FloatingActionButton(
                  heroTag: "exit_full_map",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.fullscreen_exit_rounded,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  MinMaxZoomPreference _getZoomPreference(int count) {
    return count >= 2000
        ? const MinMaxZoomPreference(16, null)
        : const MinMaxZoomPreference(19, null);
  }
}
