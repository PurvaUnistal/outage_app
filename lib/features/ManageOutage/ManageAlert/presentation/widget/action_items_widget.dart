import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/model/ViewIncidentModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/presentation/report_details_view.dart';

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
    markers.add(Marker(
      markerId: MarkerId(viewIncidentData.incidenttype!),
      infoWindow: InfoWindow(title: viewIncidentData.incidenttype!),
      position: latLng,
    ));
    return Card(
      color: AppColor.white,
      child: ListTile(
        onTap: () async {
          await SharedPref.remove(key: PrefsValue.incidentTypeId);
          await SharedPref.remove(key: PrefsValue.incidentId);
          await SharedPref.setString(
              key: PrefsValue.incidentTypeId,
              value: viewIncidentData.incidentTypeId!);
          await SharedPref.setString(
              key: PrefsValue.incidentId, value: viewIncidentData.incid!);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReportDetailsView(
                        incidentTypeId: viewIncidentData.incidentTypeId!,
                        incidentId: viewIncidentData.incid!,
                      )));
        },
        title: _rowWidget(
          title: "Report Status : ",
          subtitle: viewIncidentData.actionStatus!.index == 0
              ? AppString.newData
              : viewIncidentData.actionStatus!.index == 1
                  ? AppString.inProgress
                  : AppString.completed,
          color: viewIncidentData.actionStatus!.index == 0
              ? Colors.red
              : viewIncidentData.actionStatus!.index == 1
                  ? Colors.yellow.shade800
                  : Colors.green.shade800,
        ),
        subtitle: Column(
          children: [
            Divider(),
            _rowSubtitleWidget(
                title: "Incident Type : ",
                subtitle: viewIncidentData.incidenttype.toString()),
            _rowSubtitleWidget(
                title: "Priority : ",
                subtitle: viewIncidentData.priority.toString()),
            _rowSubtitleWidget(
                title: "Report Date : ",
                subtitle: viewIncidentData.addedDate.toString()),
            Divider(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: AppColor.primer, width: 1)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      cameraTargetBounds: CameraTargetBounds.unbounded,
                      markers: markers,
                      initialCameraPosition: CameraPosition(target: LatLng(lat, lng,), zoom: 16),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget(
      {required String title, required String subtitle, required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Styles.titleGreen,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0) //
                    ),
                border: Border.all(color: color, width: 2)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(subtitle, style: Styles.titleBlack(color: color)),
            )),
      ],
    );
  }

  Widget _rowSubtitleWidget({required String title, required String subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Styles.titleNormalBlack,
        ),
        Text(
          subtitle,
          style: Styles.titleNormalBlack,
        ),
      ],
    );
  }
}
