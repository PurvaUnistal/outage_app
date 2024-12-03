import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_border_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/background_info_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/Utils/common_widgets/row_widget.dart';
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
    int incidentTypeActionSize = dataState.listOfIncidentTypeAction.length;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        body: incidentTypeActionSize == 0
            ? Center(
            child: Text(
              "No records found",
              style: Styles.labels,
            ))
            :  ListView.builder(
            shrinkWrap: true,
            itemCount: incidentTypeActionSize,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColor.primer1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      ),
                    )),
              );
            }),
      ),
    );
  }

  Widget _nameWidget(
      {required FetchReportDetailsDataState dataState, required int i}) {
    return Text(
      dataState.listOfIncidentTypeAction[i].name!,
      textAlign: TextAlign.start,
      style: Styles.titleNormalBlack,
    );
   /* return RowWidget(
      widget1: Text("Name : ", style: Styles.titleGreen),
      widget2: Text(
        dataState.listOfIncidentTypeAction[i].name!,
        style: Styles.titleNormalBlack,
      ),
    );*/
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
                  i != listSize - 1 ?  dataState.isBtnLoader == true &&
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
                              color: AppColor.primer,
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
                                color: AppColor.primer,
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
                    color: AppColor.yellow800, text: "In Progress", onTap: () {})
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
                                color: AppColor.primer,
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
