import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/dropdown_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/image_pop_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/image_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_bloc.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_event.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/bloc/maintenance_alert_state.dart';
import 'package:igl_outage_app/features/Maintenance/MaintenanceAlert/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';

import '../domain/model/GetAreaModel.dart';
import '../domain/model/GetAssetModel.dart';
import '../domain/model/GetChargeAreaModel.dart';
import '../domain/model/GetControlRoomModel.dart';
import '../domain/model/GetIncidentIndicationModel.dart';
import '../domain/model/GetIncidentTypeModel.dart';
import '../domain/model/GetLocationSourceModel.dart';
import '../domain/model/GetPriorityTypeModel.dart';

class MaintenanceAlertView extends StatefulWidget {
  const MaintenanceAlertView({super.key});

  @override
  State<MaintenanceAlertView> createState() => _MaintenanceAlertViewState();
}

class _MaintenanceAlertViewState extends State<MaintenanceAlertView> {
  @override
  void initState() {
    BlocProvider.of<MaintenanceAlertBloc>(context).add(MaintenanceAlertLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MaintenanceAlertBloc, MaintenanceAlertState>(
          builder: (context, state) {
            if (state is FetchMaintenanceAlertDataState) {
              return  _itemBuilder(dataState: state);
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
            MessageBoxTwoButtonPopWidget(message: "Do you want to Maintenance Alert?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchMaintenanceAlertDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.maintenanceAlert,
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
        body: BackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
            child: ListView(
              children: [
                CommonStyle.vertical(context: context),
                _moduleDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _incidentTypeDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _incidentPriorityDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _locationSourceDropdown(dataState: dataState),
                _customerTypeDropdown(dataState: dataState),
                _searchNumberController(dataState: dataState),
                _assetsDropdown(dataState: dataState),
                _assetTypeIdDropdown(dataState: dataState),
                _locationController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _informationSourceDropdown(dataState: dataState),
                _infoSecurityNameController(dataState: dataState),
                _infoSecurityNumberController(dataState: dataState),
                _infoSecurityMobileController(dataState: dataState),
                _infoCustomerNameController(dataState: dataState),
                _infoCustomerNumberController(dataState: dataState),
                _infoCustomerMobileController(dataState: dataState),
                _infoOtherNameController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _addressController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _landmarkController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _incidentIndicationDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _chargeAreaDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _areaDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _controlRoomDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _descriptionController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _remarksController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _image(dataState: dataState),
                CommonStyle.vertical(context: context),
                CommonStyle.vertical(context: context),
                _button(dataState: dataState),
                CommonStyle.vertical(context: context),
                CommonStyle.vertical(context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moduleDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return DropdownWidget<GetModuleTypeData>(
      star: AppString.star,
      label: AppString.module,
      hint: AppString.module,
      dropdownValue: dataState.moduleTypeValue.id == null ? null : dataState.moduleTypeValue,
      items: dataState.listOfModuleType,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectModuleValueEvent(moduleTypeValue: val!,context: context));
      },
    );
  }
  Widget _incidentTypeDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.isModuleLoader == false ?  DropdownWidget<GetIncidentTypeData>(
      star: AppString.star,
      label: AppString.incidentType,
      hint: AppString.incidentType,
      dropdownValue: dataState.incidentTypeValue.id == null ? null : dataState.incidentTypeValue,
      items: dataState.listOfIncidentType,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectIncidentTypeValueEvent(incidentTypeValue: val!,context: context));
      },
    ) : DottedLoaderWidget();
  }
  Widget _incidentPriorityDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.isModuleLoader == false ?  DropdownWidget<GetPriorityTypeData>(
      star: AppString.star,
      label: AppString.incidentPriority,
      hint: AppString.incidentPriority,
      dropdownValue: dataState.priorityTypeValue.id == null ? null : dataState.priorityTypeValue,
      items: dataState.listOfPriorityType,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectPriorityTypeValueEvent(priorityTypeValue: val!,context: context));
      },
    ) : DottedLoaderWidget();
  }
  Widget _locationSourceDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return DropdownWidget<GetLocationSourceModel>(
      star: AppString.star,
      label: AppString.locationSource,
      hint: AppString.locationSource,
      dropdownValue: dataState.locationSourceValue.key == null ? null : dataState.locationSourceValue,
      items: dataState.listOfLocationSource,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectLocationSourceValueEvent(locationSourceValue: val!,context: context));
      },
    );
  }
  Widget _customerTypeDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.locationSourceValue.key == "1" ? CommonStyle.col(
      context: context,
      child: DropdownWidget<GetLocationSourceModel>(
        star: AppString.star,
        label: AppString.customerType,
        hint: AppString.customerType,
        dropdownValue: dataState.customerTypeValue.key == null ? null : dataState.customerTypeValue,
        items: dataState.listOfCustomerType,
        onChanged: (val) {
          BlocProvider.of<MaintenanceAlertBloc>(context)
              .add(SelectCustomerTypeValueEvent(customerTypeValue: val!,context: context));
        },
      ),
    ) : Container();
  }

  Widget _searchNumberController({required FetchMaintenanceAlertDataState dataState}) {
    if(dataState.isCustomerTypeLoader == false){
     if(dataState.locationSourceValue.key == "1"){
       if(dataState.customerTypeValue.key == "1" || dataState.customerTypeValue.key == "2" || dataState.customerTypeValue.key == "3"){
         return CommonStyle.col(
           context: context,
           child: AutoCompleteTextFieldWidget(
             star: AppString.star,
             label:dataState.customerTypeValue.key == "1" ? AppString.bpNumber
                 : dataState.customerTypeValue.key == "2" ? AppString.mobileNumber
                 : dataState.customerTypeValue.key == "3" ? AppString.meterNumber : AppString.bpNumber,
             hintText:dataState.customerTypeValue.key == "1" ? AppString.bpNumber
                 : dataState.customerTypeValue.key == "2" ? AppString.mobileNumber
                 : dataState.customerTypeValue.key == "3" ? AppString.meterNumber : AppString.bpNumber,
             controller:dataState.searchNumberController,
             suggestions: dataState.listOfSearchNumber,
             onSelected: (val) {
               BlocProvider.of<MaintenanceAlertBloc>(context).add(SelectSearchNumberControllerEvent(context: context, searchNumberValue: val));
             },
             onChanged: (val) {
               BlocProvider.of<MaintenanceAlertBloc>(context).add(SelectSearchNumberControllerEvent(context: context, searchNumberValue: val));
             },
           ),
         );
       }else{
         return Container();
       }
     }
    else {
      return Container();
    }
    }else {
      return DottedLoaderWidget();
    }
    }

  Widget _assetsDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.locationSourceValue.key == "2" ? CommonStyle.col(
      context: context,
      child: DropdownWidget<GetAssetData>(
        star: AppString.star,
        label: AppString.assets,
        hint: AppString.assets,
        dropdownValue: dataState.assetDataValue.assetId == null ? null : dataState.assetDataValue,
        items: dataState.listOfAssetData,
        onChanged: (val) {
          BlocProvider.of<MaintenanceAlertBloc>(context)
              .add(SelectAssetValueEvent(assetDataValue: val!,context: context));
        },
      ),
    ) : Container();
  }
  Widget _assetTypeIdDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.locationSourceValue.key == "2" ? CommonStyle.col(
      context: context,
      child: DropdownWidget<TfGisData>(
        star: AppString.star,
        label: AppString.assetTypeId,
        hint: AppString.assetTypeId,
        dropdownValue: dataState.assetTypeIdValue.id == null ? null : dataState.assetTypeIdValue,
        items: dataState.listOfAssetTypeId,
        onChanged: (val) {
          BlocProvider.of<MaintenanceAlertBloc>(context)
              .add(SelectAssetTypeIdValueEvent(assetTypeIdValue: val!,context: context));
        },
      ),
    ) : Container();
  }

  Widget _locationController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.locationSourceValue.key  == "3" ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.location,
          hintText: AppString.location,
          controller:dataState.locationController
      ),
    ) : Container();
  }

  Widget _addressController({required FetchMaintenanceAlertDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.address,
        hintText: AppString.address,
        controller:dataState.addressController
    );
  }

  Widget _informationSourceDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return DropdownWidget<GetPriorityTypeData>(
      star: AppString.star,
      label: AppString.informationSource,
      hint: AppString.informationSource,
      dropdownValue: dataState.informationSourceValue.id == null ? null : dataState.informationSourceValue,
      items: dataState.listOfInformationSource,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectInformationSourceValueEvent(informationSourceValue: val!,context: context));
      },
    );
  }

  Widget _infoSecurityNameController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.informationSourceValue.id == "1"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.securityGuardName,
          hintText: AppString.securityGuardName,
          controller:dataState.infoSecurityNameController
      ),
    ) : Container();
  }

  Widget _infoSecurityNumberController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.informationSourceValue.id == "1"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.securityGuardId,
          hintText: AppString.securityGuardId,
          controller:dataState.infoSecurityIdController
      ),
    ) : Container();
  }

  Widget _infoSecurityMobileController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.informationSourceValue.id == "1"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.securityGuardMobile,
          hintText:AppString.securityGuardMobile,
          controller:dataState.infoSecurityMobileController
      ),
    ) : Container();
  }
  Widget _infoCustomerNameController({required FetchMaintenanceAlertDataState dataState}) {
    return  dataState.informationSourceValue.id == "2"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.customerName,
          hintText: AppString.customerName,
          controller:dataState.infoCustomerNameController
      ),
    ) : Container();
  }

  Widget _infoCustomerNumberController({required FetchMaintenanceAlertDataState dataState}) {
    return  dataState.informationSourceValue.id == "2"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.customerBpNumber,
          hintText:AppString.customerBpNumber,
          controller:dataState.infoCustomerBpNumberController
      ),
    ) : Container();
  }

  Widget _infoCustomerMobileController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.informationSourceValue.id == "2"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.customerMobile,
          hintText:  AppString.customerMobile,
          controller:dataState.infoCustomerMobileController
      ),
    ) : Container();
  }

  Widget _infoOtherNameController({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.informationSourceValue.id == "4"
        ? CommonStyle.col(
      context: context,
      child: TextFieldWidget(
          star: AppString.star,
          label: AppString.otherName,
          hintText:AppString.otherName,
          controller:dataState.infoOtherNameController
      ),
    ) : Container();
  }

  Widget _landmarkController({required FetchMaintenanceAlertDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.landmark,
        hintText: AppString.landmark,
        controller:dataState.landmarkController
    );
  }

  Widget _incidentIndicationDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return DropdownWidget<GetIncidentIndicationData>(
      star: AppString.star,
      label: AppString.incidentIndication,
      hint: AppString.incidentIndication,
      dropdownValue: dataState.incidentIndicationValue.id == null ? null : dataState.incidentIndicationValue,
      items: dataState.listOfIncidentIndication,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectIncidentIndicationValueEvent(incidentIndicationValue: val!,context: context));
      },
    );
  }

  Widget _chargeAreaDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return DropdownWidget<GetChargeAreaModel>(
      star: AppString.star,
      label: AppString.chargeArea,
      hint: AppString.chargeArea,
      dropdownValue: dataState.chargeAreaValue.gid == null ? null : dataState.chargeAreaValue,
      items: dataState.listOfChargeArea,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectChargeAreaValueEvent(chargeAreaValue: val!,context: context));
      },
    );
  }

  Widget _areaDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.isChargeAreaLoader == false ?  DropdownWidget<GetAreaModel>(
      star: AppString.star,
      label: AppString.area,
      hint: AppString.area,
      dropdownValue: dataState.areaValue.gid == null ? null : dataState.areaValue,
      items: dataState.listOfArea,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectAreaValueEvent(areaValue: val!,context: context));
      },
    ) : DottedLoaderWidget();
  }

  Widget _controlRoomDropdown({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.isAreaLoader == false ?  DropdownWidget<GetControlRoomData>(
      star: AppString.star,
      label: AppString.controlRoom,
      hint: AppString.controlRoom,
      dropdownValue: dataState.controlRoomValue.areaId == null ? null : dataState.controlRoomValue,
      items: dataState.listOfControlRoom,
      onChanged: (val) {
        BlocProvider.of<MaintenanceAlertBloc>(context)
            .add(SelectControlRoomValueEvent(controlRoomValue: val!,context: context));
      },
    ) : DottedLoaderWidget();
  }


  Widget _descriptionController({required FetchMaintenanceAlertDataState dataState}) {
    return TextFieldWidget(
      //   star: AppString.star,
        label: AppString.description,
        hintText: AppString.description,
        controller:dataState.descriptionController
    );
  }

  Widget _remarksController({required FetchMaintenanceAlertDataState dataState}) {
    return TextFieldWidget(
      //   star: AppString.star,
        label: AppString.remarks,
        hintText: AppString.remarks,
        controller:dataState.remarksController
    );
  }

  Widget _image({required FetchMaintenanceAlertDataState dataState}){
    return ImageWidget(
      star: AppString.star,
      title: AppString.photo,
      imgFile: dataState.photo,
      onPressed: () {
        showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return ImagePopWidget(
                onTapCamera: () async {
                  Navigator.of(context).pop();
                  BlocProvider.of<MaintenanceAlertBloc>(context).add(CaptureCameraPhotoEvent());
                },
                onTapGallery: () async {
                  Navigator.of(context).pop();
                  BlocProvider.of<MaintenanceAlertBloc>(context).add(CaptureGalleryPhotoEvent());
                },
              );
            });
      },
    );
  }

  Widget _button({required FetchMaintenanceAlertDataState dataState}) {
    return dataState.isBtnLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<MaintenanceAlertBloc>(context).add(SubmitAddIncidentBtnEvent(context: context));
        })
        : DottedLoaderWidget();
  }
}