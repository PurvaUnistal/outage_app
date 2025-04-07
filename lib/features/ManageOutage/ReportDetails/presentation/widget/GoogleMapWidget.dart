import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/commonClass/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_bloc.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';

class FullGoogleMapWidget extends StatelessWidget {
  final BuildContext mContext;

  const FullGoogleMapWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return BackgroundInfoWidget(
      child: BlocBuilder<ReportDetailsBloc, ReportDetailsState>(
        builder: (context, state) {
          if (state is FetchReportDetailsDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: SpinLoader());
          }
        },
      ),
    );
  }

  _itemBuilder({required FetchReportDetailsDataState dataState}) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: dataState.incidentLocation, zoom: 12),
            markers: Set<Marker>.of(dataState.markersPointList),
            onMapCreated: (GoogleMapController controller) {
              dataState.googleMapController.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: () => Navigator.pop(mContext),
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: EnvironmentConfig.of(mContext)!.primaryTheme,
                  ),
                ),
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: () => Navigator.pop(mContext),
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.fullscreen_exit_rounded,
                    color:EnvironmentConfig.of(mContext)!.primaryTheme,
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
