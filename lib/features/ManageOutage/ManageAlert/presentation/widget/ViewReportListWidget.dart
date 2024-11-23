import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinKitDancingSquareWidget.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/ManageOutage/ManageAlert/domain/model/ViewIncidentModel.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/presentation/report_details_view.dart';

class ViewReportListWidget extends StatelessWidget {
  final List<ViewIncidentData> listOfViewIncident;
  final bool checkIncidentType;

  const ViewReportListWidget(
      {super.key,
      required this.listOfViewIncident,
      required this.checkIncidentType});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = Set();
    return checkIncidentType == false
        ? listOfViewIncident.length == 0
            ? Center(
                child: Text(
                "No records found",
                style: Styles.labels,
              ))
            : ListView.builder(
                itemCount: listOfViewIncident.length,
                itemBuilder: (BuildContext context, int i) {
                  var data = listOfViewIncident[i];
                  double lat = double.parse(data.latitude ?? " 0.0");
                  double lng = double.parse(data.longitude ?? " 0.0");
                  LatLng latLng = LatLng(lat, lng);
                  markers.add(Marker(
                    markerId: MarkerId(data.incidenttype!),
                    infoWindow: InfoWindow(title: data.incidenttype!),
                    position: latLng,
                  ));
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        await SharedPref.remove(key: PrefsValue.incidentTypeId);
                        await SharedPref.remove(key: PrefsValue.incidentId);
                        await SharedPref.setString(
                            key: PrefsValue.incidentTypeId,
                            value: data.incidentTypeId!);
                        await SharedPref.setString(
                            key: PrefsValue.incidentId, value: data.incid!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportDetailsView(
                                      incidentTypeId: data.incidentTypeId!,
                                      incidentId: data.incid!,
                                    )));
                      },
                      title: _rowWidget(
                        title: "Report Status : ",
                        subtitle: data.actionStatus == "0"
                            ? "New"
                            : data.actionStatus == "1"
                                ? "In Progress"
                                : "Completed",
                        color: data.actionStatus == "0"
                            ? Colors.red
                            : data.actionStatus == "1"
                                ? Colors.yellow.shade800
                                : Colors.green.shade800,
                      ),
                      subtitle: Column(
                        children: [
                          Divider(),
                          _rowSubtitleWidget(
                              title: "Incident Type : ",
                              subtitle: listOfViewIncident[i]
                                  .incidenttype
                                  .toString()),
                          _rowSubtitleWidget(
                              title: "Priority : ",
                              subtitle:
                                  listOfViewIncident[i].priority.toString()),
                          _rowSubtitleWidget(
                              title: "Report Date : ",
                              subtitle:
                                  listOfViewIncident[i].createdAt.toString()),
                          Divider(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0) //
                                        ),
                                border: Border.all(
                                    color: AppColor.primer, width: 1)),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: GoogleMap(
                                    cameraTargetBounds:
                                        CameraTargetBounds.unbounded,
                                    tiltGesturesEnabled: true,
                                    scrollGesturesEnabled: false,
                                    markers: markers,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          lat,
                                          lng,
                                        ),
                                        zoom: 5),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
        : SpinKitDancingSquareLoader();
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
