import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_event.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_state.dart';

class ReportPopWidget extends StatelessWidget {
  final BuildContext mContext;

  const ReportPopWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportAlertBloc, ReportAlertState>(
      builder: (context, state) {
        if (state is FetchReportAlertDataState) {
          return SingleChildScrollView(
            child: Dialog(
              backgroundColor: Colors.white70,
              insetPadding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonStyle.vertical(context: context),
                  Text(
                    state.nameofLocation,
                    textAlign: TextAlign.center,
                  ),
                  CommonStyle.vertical(context: context),
                  _tfWidget(dataState: state),
                  _valveWidget(dataState: state),
                  _regulatorWidget(dataState: state),
                  _consumerWidget(dataState: state),
                  /*   _teeWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _elbowWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _couplerWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _reducerWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _endCapWidget(dataState: state),
                  SizedBox(height: 16.0),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      children: [
                        Flexible(child: _resetBtn()),
                        SizedBox(width : 12),
                        Flexible(child: _closeBtn()),
                      ],
                    ),
                  ),
                  CommonStyle.vertical(context: context),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _tfWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxTf,
        activeColor: Colors.yellow.shade900,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxTFGisEvent(checkBoxTf: val!, context: mContext));
        },
      ),
      title: dataState.isGasTfLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Image.asset(
                  AssetPath.tf,
                  width: 20,
                  height: 20,
                ),
              ),
              label: AppString.gasTfGis,
              hintText: AppString.gasTfGis,
              enabled: dataState.checkBoxTf == true ? true : false,
             
              controller: dataState.tfGisController,
              suggestions: dataState.listOfTfGisId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext)
                    .add(SelectTFGisEvent(tfGisId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _valveWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxValve,
        activeColor: Colors.deepOrange,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxValveGisEvent(
                  checkBoxValve: val!, context: mContext));
        },
      ),
      title: dataState.isGasValveLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Image.asset(
                  AssetPath.valve,
                  width: 20,
                  height: 20,
                ),
              ),
              label: AppString.gasValveGIS,
              hintText: AppString.gasValveGIS,
              enabled: dataState.checkBoxValve == true ? true : false,
              controller: dataState.gasValveGISController,
              suggestions: dataState.listOfGasValveGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectValveGISValueEvent(
                        gasValveGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _regulatorWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxRegulator,
        activeColor: Colors.yellowAccent.shade700,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxRegulatorGisEvent(
                  checkBoxRegulator: val!, context: mContext));
        },
      ),
      title: dataState.isGasRegulatorLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Image.asset(
            AssetPath.regulator,
            width: 20,
            height: 20,
          ),
        ),
              label: AppString.gasRegulatorGIS,
              hintText: AppString.gasRegulatorGIS,
              enabled: dataState.checkBoxRegulator == true ? true : false,
             
        controller: dataState.gasRegulatorGISController,
              suggestions: dataState.listOfGasRegulatorGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectRegulatorGISValueEvent(
                        gasRegulatorGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _consumerWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxConsumer,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxConsumerGisEvent(
                  checkBoxConsumer: val!, context: mContext));
        },
      ),
      title: dataState.isGasConsumerLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Image.asset(
            AssetPath.consumer,
            width: 20,
            height: 20,
          ),
        ),
        label: AppString.gasConsumerGIS,
        hintText: AppString.gasConsumerGIS,
        enabled: dataState.checkBoxConsumer == true ? true : false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasConsumerGISController,
        suggestions: dataState.listOfGasConsumerGISId,
        onSelected: (val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectConsumerGISValueEvent(
                  gasConsumerGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _teeWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxTee,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxTeeGisEvent(checkBoxTee: val!, context: mContext));
        },
      ),
      title: dataState.isGasTeeLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: AppString.gasTeeGIS,
              hintText: AppString.gasTeeGIS,
              enabled: dataState.checkBoxTee == true ? true : false,
             
              controller: dataState.gasTeeGISController,
              suggestions: dataState.listOfGasTeeGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectTeeGISValueEvent(
                        gasTeeGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _elbowWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxElbow,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxElbowGisEvent(
                  checkBoxElbow: val!, context: mContext));
        },
      ),
      title: dataState.isGasElbowLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: AppString.gasElbowGIS,
              hintText: AppString.gasElbowGIS,
              enabled: dataState.checkBoxElbow == true ? true : false,
             
              controller: dataState.gasElbowGISController,
              suggestions: dataState.listOfGasElbowGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectElbowGISValueEvent(
                        gasElbowGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _couplerWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxCoupler,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxCouplerGisEvent(
                  checkBoxCoupler: val!, context: mContext));
        },
      ),
      title: dataState.isGasCouplerLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: AppString.gasCouplerGIS,
              hintText: AppString.gasCouplerGIS,
              enabled: dataState.checkBoxCoupler == true ? true : false,
             
              controller: dataState.gasCouplerGISController,
              suggestions: dataState.listOfGasCouplerGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectCouplerGISValueEvent(
                        gasCouplerGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _reducerWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxReducer,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxReducerGisEvent(
                  checkBoxReducer: val!, context: mContext));
        },
      ),
      title: dataState.isGasReducerLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: AppString.gasReducerGIS,
              hintText: AppString.gasReducerGIS,
              enabled: dataState.checkBoxReducer == true ? true : false,
             
              controller: dataState.gasReducerGISController,
              suggestions: dataState.listOfGasReducerGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectReducerGISValueEvent(
                        gasReducerGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _endCapWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxEndCap,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              SelectCheckBoxEndCapGisEvent(
                  checkBoxEndCap: val!, context: mContext));
        },
      ),
      title: dataState.isGasEndCapLoader == false
          ? AutoCompleteTextFieldWidget(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: AppString.gasEndCapGIS,
              hintText: AppString.gasEndCapGIS,
              enabled: dataState.checkBoxEndCap == true ? true : false,
             
              controller: dataState.gasEndCapGISController,
              suggestions: dataState.listOfGasEndCapGISId,
              onSelected: (val) {
                BlocProvider.of<ReportAlertBloc>(mContext).add(
                    SelectEndCapGISValueEvent(
                        gasEndCapGISId: val, context: mContext));
                Navigator.pop(mContext);
              },
            )
          : DottedLoaderWidget(),
    );
  }

  Widget _closeBtn() {
    return ButtonWidget(
        onPressed: () {
          Navigator.pop(mContext, true);
        },
        text: "Close");
  }

  Widget _resetBtn() {
    return ButtonWidget(
        onPressed: () {
          BlocProvider.of<ReportAlertBloc>(mContext).add(
              ResetFilterEvent(context: mContext));
        },
        text: "Reset");
  }
}
