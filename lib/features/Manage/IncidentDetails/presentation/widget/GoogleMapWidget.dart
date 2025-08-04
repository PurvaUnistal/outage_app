import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_bloc.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_event.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_state.dart';
class FullGoogleMapWidget extends StatefulWidget {
  const FullGoogleMapWidget({super.key});

  @override
  State<FullGoogleMapWidget> createState() => _FullGoogleMapWidgetState();
}

class _FullGoogleMapWidgetState extends State<FullGoogleMapWidget> {
  @override
  void initState() {
    BlocProvider.of<IncidentDetailBloc>(
      context,
    ).add(IncidentDetailLoadEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<IncidentDetailBloc, IncidentDetailState>(
        builder: (context, state) {
          if (state is FetchIncidentDetailDataState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  buildingsEnabled: false,
                  zoomControlsEnabled: false,
                  // rotateGesturesEnabled: true,
                  markers: state.markersPointList,
                  polylines: state.polylinePointList,
                  initialCameraPosition: CameraPosition(
                    target: state.incidentLocation,
                  ),
                  minMaxZoomPreference: _getZoomPreference(state.markersPointList.length),
                  onCameraIdle: () {
                    BlocProvider.of<IncidentDetailBloc>(context).add(IncidentDetailOnCameraIdleEvent(
                      latLng: state.incidentLocation,
                    ));
                  },
                  onMapCreated: (GoogleMapController controller) {
                    if (! state.googleMapController.isCompleted) {
                      state.googleMapController.complete(controller);
                    }
                  },
                ),
                Positioned(
                  bottom: 100,
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
            );
          } else {
            return const Center(child: SpinLoader());
          }
        },
      ),
    );
  }

  MinMaxZoomPreference _getZoomPreference(int count) {
    return count >= 2000
        ? const MinMaxZoomPreference(16, null)
        : const MinMaxZoomPreference(19, null);
  }
}
