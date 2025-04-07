import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/commonClass/environment_config.dart';
import 'package:outage_app/features/ManageOutage/ManageAlert/presentation/widget/button_border_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_bloc.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_event.dart';
import 'package:outage_app/features/ManageOutage/ReportDetails/domain/bloc/report_details_state.dart';
import 'widget/GoogleMapWidget.dart';

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
      /* appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
       // brightness: Brightness.light,
      ),*/
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
      body: SafeArea(
        child: Column(
          children: [
            _googleMap(dataState: dataState),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _listOfAffect(dataState: dataState),
                  _listOfIncident(dataState: dataState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listOfAffect({required FetchReportDetailsDataState dataState}) {
    return SizedBox(
      height: dataState.listOfConsumer.isNotEmpty && dataState.listOfValve.isNotEmpty ?  MediaQuery.of(context).size.height / 8 :MediaQuery.of(context).size.height / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _listOfValve(dataState: dataState),
          VerticalDivider(
            color: EnvironmentConfig.of(context)!.primaryTheme,
          ),
          _listOfConsumer(dataState: dataState),
        ],
      ),
    );
  }

  Widget _listOfValve({required FetchReportDetailsDataState dataState}) {
    return _affectWidget(
      title:  "Valve Affected",
      children: dataState.listOfValve
          .map((e) => Column(
            children: [
              Divider(),
              Text(e.valveId ?? "", style: TextStyle(
                fontSize: 12,
                fontFamily: 'Cutive',
              ),),
            ],
          ))
          .toList(),
    );
  }

  Widget _listOfConsumer({required FetchReportDetailsDataState dataState}) {
    return _affectWidget(
      title:  "Customer Affected",
      children: dataState.listOfConsumer.map((e) => Column(
        children: [
          Divider(),
          Text(e.bpNumber ?? "", style: TextStyle(
            fontSize: 12,
            fontFamily: 'Cutive',
          )),
        ],
      )).toList(),
    );
  }

  Widget _listOfIncident({required FetchReportDetailsDataState dataState}) {
    int incidentTypeActionSize = dataState.listOfIncidentTypeAction.length;
    print("========>${MediaQuery.of(context).size.height / 2}");
    return
        /* incidentTypeActionSize == 0
        ? Center(
            child: Text(
            "No records found",
            style: Styles.labels,
          ))
        :*/
        Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: incidentTypeActionSize,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: EnvironmentConfig.of(context)!.primaryTheme,),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        _nameWidget(dataState: dataState, i: i),
                        _dividerWidget(dataState: dataState, i: i),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _actionWidget(
                                dataState: dataState,
                                i: i,
                                listSize: incidentTypeActionSize),
                            _statusWidget(dataState: dataState, i: i),
                          ],
                        ),
                      ],
                    )),
              );
            }),
      ),
    );
  }


  Widget _googleMap({required FetchReportDetailsDataState dataState}) {
    var h = MediaQuery.of(context).size.height;
    return Container(
        height: h * 0.2,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              cameraTargetBounds: CameraTargetBounds.unbounded,
              markers: dataState.markersPointList,
              initialCameraPosition:
                  CameraPosition(target: dataState.incidentLocation, zoom: 14),
              onMapCreated: (GoogleMapController controller) {
                dataState.googleMapController.complete(controller);
              },
            ),
            Positioned(
              top: 0,
              right:0,
              child:  CircleAvatar(
                  backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
                  child: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullGoogleMapWidget(mContext: context,)),
                        );
                      },
                   icon: Icon( Icons.fullscreen_rounded, color: AppColor.white)),
              ),
            ),
          ],
        ));
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
                          color: Colors.blue.shade800,
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
                              color: Colors.yellow.shade800,
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
                              color: AppColor.blue,
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
                                color: Colors.yellow.shade800,
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
                                color: Colors.yellow.shade800,
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

  Widget _affectWidget({required String title, required List<Widget> children }) {
    return Flexible(
        fit: FlexFit.loose,
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: EnvironmentConfig.of(context)!.primaryTheme,),
                ),
                Column(
                 /* mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,*/
                  children: children.isNotEmpty
                      ? children
                      : [
                        Divider(),
                        Text("No Data",textAlign: TextAlign.center, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontFamily: 'Cutive'))],
                )

              ],
            )));
  }
}
