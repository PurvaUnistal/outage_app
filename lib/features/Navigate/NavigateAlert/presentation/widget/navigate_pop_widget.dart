import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';

class NavigatePopWidget extends StatelessWidget {
  final BuildContext mContext;

  const NavigatePopWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
      builder: (context, state) {
        if (state is FetchNavigateAlertDataState) {
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
                  _servicePointWidget(dataState: state),
                  _regulatorWidget(dataState: state),
                  _commercialWidget(dataState: state),
                  _domesticWidget(dataState: state),
                  _industrialWidget(dataState: state),
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

  Widget _tfWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkTf,
        activeColor: Colors.yellow.shade900,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxTFGisEvent(checkTf: val!, context: mContext));
        },
      ),
      title: dataState.isTfLoader == false
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
        enabled: dataState.checkTf == true ? true : false,

        controller: dataState.tfController,
        suggestions: dataState.listOfTfId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext)
              .add(SelectTFGisEvent(tfGisId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _valveWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkValve,
        activeColor: Colors.deepOrange,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxValveGisEvent(
                  checkBoxValve: val!, context: mContext));
        },
      ),
      title: dataState.isValveLoader == false
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
        enabled: dataState.checkValve == true ? true : false,
        controller: dataState.valveController,
        suggestions: dataState.listOfValveId,
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

  Widget _servicePointWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkService,
        activeColor: Colors.deepOrange,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
            SelectCheckBoxServiceGisEvent(checkBoxService: val!, context: mContext),
          );
        },
      ),
      title:
      dataState.isServiceLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Image.asset(AssetPath.service, width: 20, height: 20),
        ),
        label: AppString.gasServiceGIS,
        hintText: AppString.gasServiceGIS,
        enabled: dataState.checkService == true ? true : false,
        controller: dataState.serviceController,
        suggestions: dataState.listOfServiceId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
            SelectServiceGISServiceEvent(
              gasServiceGISId: val,
              context: mContext,
            ),
          );
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }
  Widget _regulatorWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkRegulator,
        activeColor: Colors.yellowAccent.shade700,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckBoxRegulatorGisEvent(
                  checkBoxRegulator: val!, context: mContext));
        },
      ),
      title: dataState.isRegulatorLoader == false
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
        enabled: dataState.checkRegulator == true ? true : false,

        controller: dataState.regulatorController,
        suggestions: dataState.listOfRegulatorId,
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

  Widget _commercialWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkCommercial,
        activeColor: Colors.deepOrangeAccent,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckCommercialEvent(
                  checkCommercial: val!, context: mContext));
        },
      ),
      title: dataState.isCommercialLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Icon(Icons.circle, color: Colors.deepOrangeAccent,size: 12,),
        ),
        label: AppString.commercial,
        hintText: AppString.commercial,
        enabled: dataState.checkCommercial == true ? true : false,
        keyboardType: TextInputType.number,
        controller: dataState.commercialController,
        suggestions: dataState.listOfCommercialId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCommercialValueEvent(
                  commercialId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _domesticWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkDomestic,
        activeColor: Colors.yellowAccent,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckDomesticEvent(checkDomestic: val!, context: mContext));
        },
      ),
      title: dataState.isDomesticLoader == false
          ? AutoCompleteTextFieldWidget(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Icon(Icons.circle, color: Colors.yellowAccent,size: 12,),
        ),
        label: AppString.domestic,
        hintText: AppString.domestic,
        enabled: dataState.checkDomestic == true ? true : false,

        controller: dataState.domesticController,
        suggestions: dataState.listOfDomesticId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectDomesticValueEvent(
                  domesticId: val, context: mContext));
          Navigator.pop(mContext);
        },
      )
          : DottedLoaderWidget(),
    );
  }

  Widget _industrialWidget({required FetchNavigateAlertDataState dataState}) {
    return ListTile(
      leading: Checkbox(
        value: dataState.checkIndustrial,
        activeColor: Colors.blue.shade800,
        onChanged: (bool? val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectCheckIndustrialEvent(
                  checkIndustrial: val!, context: mContext));
        },
      ),
      title: dataState.isIndustrialLoader == false
          ? AutoCompleteTextFieldWidget(
    prefixIcon: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.0),
    child: Icon(Icons.circle, color: Colors.blue.shade800,size: 12,),
    ),
        label: AppString.industrial,
        hintText: AppString.industrial,
        enabled: dataState.checkIndustrial == true ? true : false,

        controller: dataState.industrialController,
        suggestions: dataState.listOfIndustrialId,
        onSelected: (val) {
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              SelectIndustrialValueEvent(
                  industrialId: val, context: mContext));
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
          BlocProvider.of<NavigateAlertBloc>(mContext).add(
              ResetFilterEvent(context: mContext));
        },
        text: "Reset");
  }
}
