import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_bloc.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_event.dart';
import 'package:outage_app/features/Manage/IncidentDetails/domain/bloc/incident_details_state.dart';

class FullGoogleMapWidget extends StatefulWidget {
  const FullGoogleMapWidget({super.key,});

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
    return BackgroundInfoWidget(
      child: BlocBuilder<IncidentDetailBloc, IncidentDetailState>(
        builder: (context, state) {
          if (state is FetchIncidentDetailDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: SpinLoader());
          }
        },
      ),
    );
  }

  _itemBuilder({required FetchIncidentDetailDataState dataState}) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(AppString.zoom, null),
            initialCameraPosition:
                CameraPosition(target: dataState.incidentLocation, zoom: AppString.zoom),
            markers: Set<Marker>.of(dataState.markersPointList),
            polylines: dataState.polylinePointList,
            onCameraIdle: () {
              BlocProvider.of<IncidentDetailBloc>(context).add(IncidentDetailOnCameraIdleEvent(
                context: context,
              ));
            },
            onMapCreated: (GoogleMapController controller) {
              if (! dataState.googleMapController.isCompleted) {
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
                    color:EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
