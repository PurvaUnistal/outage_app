import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_event.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/bloc/report_alert_state.dart';

class ReportPopWidget extends StatefulWidget {
 final BuildContext mContext;
  const ReportPopWidget({super.key, required this.mContext});

  @override
  State<ReportPopWidget> createState() => _ReportPopWidgetState();
}

class _ReportPopWidgetState extends State<ReportPopWidget> {

  @override
  void initState() {
    BlocProvider.of<ReportAlertBloc>(context).add(ReportAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportAlertBloc, ReportAlertState>(
      builder: (context, state) {
        if (state is FetchReportAlertDataState) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(2),
            contentPadding: EdgeInsets.all(2),
            insetPadding: EdgeInsets.all(5),
              content: _itemBuilder(dataState: state),

          );
        } else {
          return const Center(child: SpinLoader());
        }
      },
    );
  }
  Widget _itemBuilder({required FetchReportAlertDataState dataState}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16.0),
        Text(dataState.nameofLocation, textAlign: TextAlign.center,),
        SizedBox(height: 16.0),
        _tfGisTextFieldWidget(dataState: dataState),
        SizedBox(height: 16.0),
        _gasValveGISTextFieldWidget(dataState: dataState),
        SizedBox(height: 16.0),
      ],
    ),
  );
  }

  Widget _tfGisTextFieldWidget({required FetchReportAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkBoxTf,
        activeColor: Colors.cyanAccent,
        onChanged: (bool? val){
          BlocProvider.of<ReportAlertBloc>(widget.mContext)
              .add(SelectCheckBoxTFGisEvent(checkBoxTf: val!,context: widget.mContext));
        },
      ),
      title: dataState.isGasTfLoader == false ? AutoCompleteTextFieldWidget(
        prefixIcon: Icon(Icons.location_on, color: Colors.cyanAccent,),
        label: AppString.tfGis,
        hintText: AppString.tfGis,
        keyboardType: TextInputType.number,
        controller: dataState.tfGisController,
        suggestions: dataState.listOfTfGisId,
        onSelected: (val) {
          BlocProvider.of<ReportAlertBloc>(widget.mContext)
              .add(SelectTFGisEvent(tfGisId: val,context: widget.mContext));
          Navigator.pop(context);
        },
      ) : DottedLoaderWidget(),
    );
  }

  Widget _gasValveGISTextFieldWidget({required FetchReportAlertDataState dataState}) {
    return  ListTile(
      leading: Checkbox(
        value: dataState.checkBoxValve,
        activeColor: Colors.green,
        onChanged: (bool? val){
          BlocProvider.of<ReportAlertBloc>(widget.mContext)
              .add(SelectCheckBoxValveGisEvent(checkBoxValve: val!,context: widget.mContext));
        },
      ),
      title: dataState.isGasValveLoader == false ? AutoCompleteTextFieldWidget(
        prefixIcon: Icon(Icons.location_on, color: Colors.green,),
        label: AppString.gasValveGIS,
        hintText: AppString.gasValveGIS,
        keyboardType: TextInputType.number,
        controller: dataState.gasValveGISController,
        suggestions: dataState.listOfGasValveGISId,
        onSelected: (val) {
          BlocProvider.of<ReportAlertBloc>(widget.mContext)
              .add(SelectValveGISValueEvent(gasValveGISId: val,context: widget.mContext));
          Navigator.pop(context);
        },
      ): DottedLoaderWidget(),
    );
  }
}
