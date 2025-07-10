import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Manage/IncidentDetails/presentation/incident_details_view.dart';
import 'package:outage_app/features/Manage/IncidentManage/domain/model/ViewIncidentModel.dart';
import 'package:outage_app/features/Manage/IncidentManage/helper/incident_manage_helper.dart';


class ActionItemsWidget extends StatelessWidget {
  final ViewIncidentData viewIncidentData;

  const ActionItemsWidget({super.key, required this.viewIncidentData});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = Set();
    double lat = double.parse(viewIncidentData.incidentLatitude ?? " 0.0");
    double lng = double.parse(viewIncidentData.incidentLongitude ?? " 0.0");
    LatLng latLng = LatLng(lat, lng);
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId(viewIncidentData.incidenttype!),
        infoWindow: InfoWindow(title: viewIncidentData.incidenttype!),
        position: latLng,
      ),
    );
    return Card(
      color: AppColor.white,
      child: ListTile(
        onTap: () async {
          final appConfig = AppConfig.instanceInit();
          if (appConfig != null) {
            await appConfig.setViewIncidentData(newViewIncidentData: viewIncidentData);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => IncidentDetailView(
                    incidentTypeId: viewIncidentData.incidentTypeId!,
                    incidentId: viewIncidentData.incid!,
                  ),
            ),
          );
        },
        title: _rowWidget(
          title: "Report Status : ",
          subtitle: IncidentManageHelper.getStatusText(
            viewIncidentData.actionStatus,
          ),
          color: IncidentManageHelper.getStatusColor(
            viewIncidentData.actionStatus,
          ),
        ),
        subtitle: Column(
          children: [
            Divider(),
            _rowSubtitleWidget(
              title: "Incident Type : ",
              subtitle: viewIncidentData.incidenttype.toString(),
            ),
            _rowSubtitleWidget(
              title: "Priority : ",
              subtitle: viewIncidentData.priority.toString(),
            ),
            _rowSubtitleWidget(
              title: "Report Date : ",
              subtitle: viewIncidentData.addedDate.toString(),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: GoogleMap(
                    rotateGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: AppString.zoom,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Styles.titleGreen),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0), //
            ),
            border: Border.all(color: color, width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(subtitle, style: Styles.titleBlack(color: color)),
          ),
        ),
      ],
    );
  }

  Widget _rowSubtitleWidget({required String title, required String subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Styles.titleNormalBlack),
        Text(subtitle, style: Styles.titleNormalBlack),
      ],
    );
  }
}
