import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_event.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_state.dart';
import '../../../../Utils/common_widgets/res/app_string.dart';

class ReportAlertView extends StatefulWidget {
  const ReportAlertView({super.key});

  @override
  State<ReportAlertView> createState() => _ReportAlertViewState();
}

class _ReportAlertViewState extends State<ReportAlertView> {
  Completer<GoogleMapController> mapController = Completer();
  @override
  void initState() {
    BlocProvider.of<ReportAlertBloc>(context).add(ReportAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await mapController.future;
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackgroundWidget(
        child: BlocBuilder<ReportAlertBloc, ReportAlertState>(
          builder: (context, state) {
            if (state is FetchReportAlertDataState) {
              return  BackgroundWidget(child: _itemBuilder(dataState: state));
            } else {
              return const Center(child: SpinLoader());
            }
          },
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) =>
            MessageBoxTwoButtonPopWidget(message: "Do you want to Report Alert?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchReportAlertDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBarWidget(
            title: AppString.reportAlert,
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
          body:Stack(
              children: <Widget>[
                _googleMapWidget(dataState:dataState),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        _mapTypeButtonWidget(dataState: dataState),
                        SizedBox(height: 16.0),
                        _currentLocationButtonWidget(dataState: dataState),
                        SizedBox(height: 16.0),
                        _filterButtonWidget(dataState: dataState),
                      ],
                    ),

                  ),
                ),
              ]
          )
      ),
    );
  }
  _googleMapWidget({required FetchReportAlertDataState dataState}){
    return  dataState.isPipelineLoader == false ? GoogleMap(
      mapType: dataState.currentMapType,
      compassEnabled: true,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      markers: dataState.markersPointList,
      polylines: dataState.polylineList,
      initialCameraPosition: CameraPosition(
        target: dataState.loginPosition,
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller){
        // mapController.complete(controller);
      },
    ) : Center(child: SpinLoader());
  }

  _mapTypeButtonWidget({required FetchReportAlertDataState dataState}){
    return  FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: ()=>BlocProvider.of<ReportAlertBloc>(context).add(
          SelectMapTypeButtonEvent()),
      backgroundColor: AppColor.primer,
      child: Icon(Icons.layers, size: 21.0, color: AppColor.white,),
    );
  }

  _currentLocationButtonWidget({required FetchReportAlertDataState dataState}){
    return  FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: (){},
      backgroundColor: AppColor.primer,
      child: Icon(Icons.my_location_rounded, size: 21.0, color: AppColor.white,),
    );
  }

  _filterButtonWidget({required FetchReportAlertDataState dataState}){
    return  FloatingActionButton(
      heroTag: UniqueKey(),
      backgroundColor: AppColor.primer,
      child: Icon(Icons.filter_alt, size: 21.0, color: AppColor.white,),
      onPressed: (){
        dataState.tfGisController.text = '';
        dataState.gasValveGISController.text = '';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(dataState.nameofLocation),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    _tfGisTextFieldWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                    _gasValveGISTextFieldWidget(dataState: dataState),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _tfGisTextFieldWidget({required FetchReportAlertDataState dataState}) {
    return AutoCompleteTextFieldWidget(
      star: AppString.star,
      label: AppString.tfGis,
      hintText: AppString.tfGis,
      keyboardType: TextInputType.number,
      controller: dataState.tfGisController,
      suggestions: dataState.listOfTfGisId,
      onSelected: (val) {
        BlocProvider.of<ReportAlertBloc>(context)
            .add(SelectTFGisEvent(tfGisId: val,context: context));
        Navigator.pop(context);
      },
    );
  }

  Widget _gasValveGISTextFieldWidget({required FetchReportAlertDataState dataState}) {
    return  AutoCompleteTextFieldWidget(
      star: AppString.star,
      label: AppString.gasValveGIS,
      hintText: AppString.gasValveGIS,
      keyboardType: TextInputType.number,
      controller: dataState.gasValveGISController,
      suggestions: dataState.listOfGasValveGISId,
      onSelected: (val) {
        BlocProvider.of<ReportAlertBloc>(context)
            .add(SelectValveGISValueEvent(gasValveGISId: val,context: context));
        Navigator.pop(context);
      },
    );
  }

}