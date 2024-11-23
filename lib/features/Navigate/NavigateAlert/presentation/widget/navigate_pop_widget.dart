import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:igl_outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';

class NavigatePopWidget extends StatelessWidget {
  final BuildContext mContext;
  const NavigatePopWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
      builder: (context, state) {
        if(state is FetchNavigateAlertDataState ){
          return SingleChildScrollView(
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    state.nameofLocation,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  _tfWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _valveWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _regulatorWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _teeWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _elbowWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _couplerWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _reducerWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _endCapWidget(dataState: state),
                  SizedBox(height: 16.0),
                  _closeBtn(),
                  SizedBox(height: 16.0),
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

  Widget _tfWidget({required FetchNavigateAlertDataState dataState}){
    return  ListTile(
      leading: Checkbox(
        value: dataState.checkBoxTf,
        activeColor: Colors.cyanAccent,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxTFGisEvent(
                  checkBoxTf: val!, context: mContext));
        },
      ),
      title: dataState.isGasTfLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Icon(
          Icons.location_on,
          color: Colors.cyanAccent,
        ),
        label: AppString.tfGis,
        hintText: AppString.tfGis,
        enabled: dataState.checkBoxTf == true ? true : false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.tfGisController,
        suggestions: dataState.listOfTfGisId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext)
              .add(SelectTFGisEvent(
              tfGisId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _valveWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxValve,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxValveGisEvent(
                  checkBoxValve: val!, context: mContext));
        },
      ),
      title: dataState.isGasValveLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        label: AppString.gasValveGIS,
        hintText: AppString.gasValveGIS,
        enabled: dataState.checkBoxValve == true ? true : false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasValveGISController,
        suggestions: dataState.listOfGasValveGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectValveGISValueEvent(
                  gasValveGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _regulatorWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxRegulator,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxRegulatorGisEvent(
                  checkBoxRegulator: val!, context: mContext));
        },
      ),
      title: dataState.isGasRegulatorLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        label: AppString.gasRegulatorGIS,
        hintText: AppString.gasRegulatorGIS,
        enabled: dataState.checkBoxRegulator == true ? true : false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasRegulatorGISController,
        suggestions: dataState.listOfGasRegulatorGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectRegulatorGISValueEvent(
                  gasRegulatorGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _teeWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxTee,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxTeeGisEvent(
                  checkBoxTee: val!, context: mContext));
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasTeeGISController,
        suggestions: dataState.listOfGasTeeGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectTeeGISValueEvent(
                  gasTeeGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _elbowWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxElbow,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasElbowGISController,
        suggestions: dataState.listOfGasElbowGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectElbowGISValueEvent(
                  gasElbowGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _couplerWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxCoupler,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasCouplerGISController,
        suggestions: dataState.listOfGasCouplerGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCouplerGISValueEvent(
                  gasCouplerGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _reducerWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxReducer,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasReducerGISController,
        suggestions: dataState.listOfGasReducerGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectReducerGISValueEvent(
                  gasReducerGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _endCapWidget({required FetchNavigateAlertDataState dataState}){
    return   ListTile(
      leading: Checkbox(
        value: dataState.checkBoxEndCap,
        activeColor: Colors.green,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: dataState.gasEndCapGISController,
        suggestions: dataState.listOfGasEndCapGISId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectEndCapGISValueEvent(
                  gasEndCapGISId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _closeBtn(){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ButtonWidget(onPressed: (){
          Navigator.pop(mContext, true);
        }, text: "Close"),
      ),
    );
  }
}

