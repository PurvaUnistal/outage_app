import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_border_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/icon_button.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_bloc.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_event.dart';
import 'package:igl_outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';

class ReportDetailsView extends StatefulWidget {
  final String incidentId;
  final String incidentTypeId;

  const ReportDetailsView(
      {super.key, required this.incidentId, required this.incidentTypeId});

  @override
  State<ReportDetailsView> createState() => _ReportDetailsViewState();
}

class _ReportDetailsViewState extends State<ReportDetailsView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    BlocProvider.of<ReportDetailsBloc>(context)
        .add(ReportDetailsLoadEvent(context: context));

    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

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

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Report Details?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchReportDetailsDataState dataState}) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Report",
        boolLeading: true,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dataState.userName,
                textAlign: TextAlign.start,
                style: Styles.rel,
              ),
              Text(
                dataState.scheme,
                textAlign: TextAlign.start,
                style: Styles.rel,
              )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _listOfConsumerAffect(dataState: dataState),
          _listOfIncident(dataState: dataState),
          _googleMap(dataState: dataState),
        ],
      ),
    );
  }

  Widget _listOfConsumerAffect(
      {required FetchReportDetailsDataState dataState}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: dataState.listOfConsumer.length == 0 ||
                  dataState.listOfValve.length == 0
              ? dataState.listOfValve.length
              : dataState.listOfConsumer.length,
          itemBuilder: (BuildContext context, int i) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _affectWidget(
                              headline: "Valve Affected", label: "V033"),
                          // headline: "Valve Affected", label: dataState.listOfValve[i].wkt!),
                          _affectWidget(
                            headline: "Customer Affected",
                            label: dataState.listOfConsumer[i].bpNumber!,
                          )
                        ],
                      ))),
            );
          }),
    );
  }

  Widget _listOfIncident({required FetchReportDetailsDataState dataState}) {
    int incidentTypeActionSize = dataState.listOfIncidentTypeAction.length;
    return incidentTypeActionSize == 0
        ? Center(
            child: Text(
            "No records found",
            style: Styles.labels,
          ))
        : SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: incidentTypeActionSize,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColor.primer),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _nameWidget(dataState: dataState, i: i),
                              _dividerWidget(dataState: dataState, i: i),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _actionWidget(
                                      dataState: dataState,
                                      i: i,
                                      listSize: incidentTypeActionSize),
                                  _statusWidget(dataState: dataState, i: i),
                                ],
                              ),
                            ],
                          ),
                        )),
                  );
                }),
          );
  }

  Widget _googleMap({required FetchReportDetailsDataState dataState}) {
    return Flexible(
        child: Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          cameraTargetBounds: CameraTargetBounds.unbounded,
          markers: dataState.isBlinkMarker ? Set<Marker>.of(dataState.markersPointList) : {},
          initialCameraPosition:
              CameraPosition(target: dataState.incidentLocation, zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            dataState.googleMapController.complete(controller);
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.primer,
                child: IconButtonWidget(
                  iconData: Icons.fullscreen_rounded,
                  onPressed: () => _showDialog(dataState: dataState),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.009),
              CircleAvatar(
                backgroundColor: AppColor.primer,
                child: IconButtonWidget(
                  iconData: Icons.layers,
                  onPressed: () {},
                  /* onPressed: () => BlocProvider.of<RiserFormBloc>(context)
                          .add(RiserMapTypeEvent(context: context)),*/
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  _showDialog({required FetchReportDetailsDataState dataState}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              body: SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: dataState.incidentLocation, zoom: 12),
                  markers: Set<Marker>.of(dataState.markersPointList),
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                  },
                ),
                Positioned(
                    left: 15,
                    top: 60,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.primer,
                          child: IconButtonWidget(
                            iconData: Icons.fullscreen_exit_rounded,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ));
        });
  }

  Widget _affectWidget({required String headline, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          headline,
          style: TextStyle(fontSize: 12, color: AppColor.primer),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColor.black),
        )
      ],
    );
  }

  Widget _nameWidget(
      {required FetchReportDetailsDataState dataState, required int i}) {
    return Text(
      dataState.listOfIncidentTypeAction[i].name!,
      textAlign: TextAlign.start,
      style: Styles.titleNormalBlack,
    );
  }

  Widget _dividerWidget(
      {required FetchReportDetailsDataState dataState, required int i}) {
    var dataType = dataState.listOfIncidentTypeAction[i];
    return dataType.actionStatusEnable == false && dataType.actionStatus == null
        ? Container()
        : Divider();
  }

  Widget _actionWidget(
      {required FetchReportDetailsDataState dataState,
      required int i,
      required int listSize}) {
    var dataType = dataState.listOfIncidentTypeAction[i];
    return _colWidget(
        title: dataType.actionStatusEnable == false &&
                dataType.actionStatus == null
            ? ""
            : "Action",
        child: dataType.actionStatusEnable == true
            ? Row(
                children: [
                  dataState.isBtnLoader == true &&
                          dataState.currentActionStatus == "1"
                      ? DottedLoaderWidget()
                      : ButtonColorWidget(
                          color: AppColor.primer,
                          text: "Start",
                          onTap: () {
                            BlocProvider.of<ReportDetailsBloc>(context)
                                .add(SubmitBtnEvent(
                              context: context,
                              incidentActionId: dataType.id.toString(),
                              actionStatus: "1",
                              row: i.toString(),
                            ));
                          }),
                  SizedBox(
                    width: 8,
                  ),
                  i != listSize - 1
                      ? dataState.isBtnLoader == true &&
                              dataState.currentActionStatus == "2"
                          ? DottedLoaderWidget()
                          : ButtonColorWidget(
                              color: AppColor.primer1,
                              text: "Skip",
                              onTap: () {
                                BlocProvider.of<ReportDetailsBloc>(context)
                                    .add(SubmitBtnEvent(
                                  context: context,
                                  incidentActionId: dataType.id.toString(),
                                  actionStatus: "2",
                                  row: i.toString(),
                                ));
                              })
                      : Container(),
                ],
              )
            : dataType.actionStatus == "1"
                ? Row(
                    children: [
                      dataState.isBtnLoader == true &&
                              dataState.currentActionStatus == "4"
                          ? DottedLoaderWidget()
                          : ButtonColorWidget(
                              color: AppColor.primer1,
                              text: "Complete",
                              onTap: () {
                                BlocProvider.of<ReportDetailsBloc>(context)
                                    .add(SubmitBtnEvent(
                                  context: context,
                                  incidentActionId: dataType.id.toString(),
                                  actionStatus: "4",
                                  row: i.toString(),
                                ));
                              }),
                      SizedBox(
                        width: 8,
                      ),
                      i != listSize - 1
                          ? (dataState.isBtnLoader == true &&
                                  dataState.currentActionStatus == "3")
                              ? DottedLoaderWidget()
                              : ButtonColorWidget(
                                  color: AppColor.black,
                                  text: "Abort",
                                  onTap: () {
                                    BlocProvider.of<ReportDetailsBloc>(context)
                                        .add(SubmitBtnEvent(
                                      context: context,
                                      incidentActionId: dataType.id.toString(),
                                      actionStatus: "3",
                                      row: i.toString(),
                                    ));
                                  })
                          : Container(),
                    ],
                  )
                : dataType.actionStatus == "2"
                    ? ButtonColorWidget(
                        color: AppColor.grey, text: "Skipped", onTap: () {})
                    : dataType.actionStatus == "3"
                        ? ButtonColorWidget(
                            color: AppColor.black,
                            text: "Aborted",
                            onTap: () {})
                        : dataState.listOfIncidentTypeAction[i].actionStatus ==
                                "4"
                            ? ButtonColorWidget(
                                color: AppColor.primer1,
                                text: "Completed",
                                onTap: () {})
                            : Container());
  }

  Widget _statusWidget(
      {required FetchReportDetailsDataState dataState, required int i}) {
    var dataType = dataState.listOfIncidentTypeAction[i];
    return _colWidget(
        title: dataType.actionStatusEnable == false &&
                dataType.actionStatus == null
            ? ""
            : "Status",
        child: dataType.actionStatus == null &&
                dataType.actionStatusEnable == true
            ? ButtonBorderWidget(
                color: AppColor.red, text: "Not Started", onTap: () {})
            : dataType.actionStatus == "1"
                ? ButtonBorderWidget(
                    color: AppColor.yellow800,
                    text: "In Progress",
                    onTap: () {})
                : dataType.actionStatus == "2"
                    ? ButtonBorderWidget(
                        color: AppColor.grey, text: "Skipped", onTap: () {})
                    : dataType.actionStatus == "3"
                        ? ButtonBorderWidget(
                            color: AppColor.black,
                            text: "Aborted",
                            onTap: () {})
                        : dataState.listOfIncidentTypeAction[i].actionStatus ==
                                "4"
                            ? ButtonBorderWidget(
                                color: AppColor.primer1,
                                text: "Completed",
                                onTap: () {})
                            : Container());
  }

  Widget _colWidget({required String title, required Widget child}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: Styles.titleGreen),
        SizedBox(
          height: 8,
        ),
        child,
      ],
    );
  }

}
