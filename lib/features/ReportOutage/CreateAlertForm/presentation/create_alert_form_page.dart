import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/background_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/dropdown_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/image_pop_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/image_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/Utils/common_widgets/row_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_bloc.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_event.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_state.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAssetModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';

import 'widget/voice_record_widget.dart';

class CreateAlertFormView extends StatefulWidget {
  const CreateAlertFormView({super.key});

  @override
  State<CreateAlertFormView> createState() => _CreateAlertFormViewState();
}

class _CreateAlertFormViewState extends State<CreateAlertFormView> {
  @override
  void initState() {
/*    LatLng  _latLngDate =   BlocProvider.of<ReportAlertBloc>(context).latLngData;*/
    BlocProvider.of<CreateAlertFormBloc>(context).add(CreateAlertFormLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CreateAlertFormBloc, CreateAlertFormState>(
          builder: (context, state) {
            if (state is FetchCreateAlertFormDataState) {
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
            MessageBoxTwoButtonPopWidget(message: "Do you want to Create Alert Form?", okButtonText: "Exit", onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchCreateAlertFormDataState dataState}) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.createAlertForm,
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
                RowWidget(
                    widget1: _currentLatController(dataState: dataState),
                    widget2: _currentLongController(dataState: dataState)
                ),
                CommonStyle.vertical(context: context),
              /*  _tfValveIdController(dataState: dataState),
                CommonStyle.vertical(context: context),*/
                _incidentTypeDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _incidentIndicationDropdown(dataState: dataState),
                CommonStyle.vertical(context: context),
                _assetIdController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _assetTypeIdController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _landmarkController(dataState: dataState),
                CommonStyle.vertical(context: context),
                _addressController(dataState: dataState),
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
  Widget _tfValveIdController({required FetchCreateAlertFormDataState dataState}){
    return TextFieldWidget(
        star: AppString.star,
        label: dataState.tfGisIdController.text == ""? AppString.gasValveGisId:AppString.gasTfGisId,
        hintText: dataState.tfGisIdController.text == "" ? AppString.gasValveGisId: AppString.gasTfGisId,
        enabled: false,
        controller:dataState.tfGisIdController.text == "" ? dataState.valveGisIdController : dataState.tfGisIdController
    );
  }
  Widget _currentLatController({required FetchCreateAlertFormDataState dataState}){
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.currentLat,
        hintText: AppString.currentLat,
        enabled: true,
        controller:dataState.currentLatitudeController
    );
  }
  Widget _currentLongController({required FetchCreateAlertFormDataState dataState}){
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.currentLong,
        hintText: AppString.currentLong,
        enabled: true,
        controller:dataState.currentLongitudeController
    );
  }

  Widget _incidentTypeDropdown({required FetchCreateAlertFormDataState dataState}) {
    return DropdownWidget<GetIncidentTypeData>(
      star: AppString.star,
      label: AppString.incidentType,
      hint: AppString.incidentType,
      dropdownValue: dataState.incidentTypeValue.id == null ? null : dataState.incidentTypeValue,
      items: dataState.listOfIncidentType,
      onChanged: (val) {
        BlocProvider.of<CreateAlertFormBloc>(context)
            .add(SelectIncidentTypeValueEvent(incidentTypeValue: val!,context: context));
      },
    );
  }
  Widget _incidentIndicationDropdown({required FetchCreateAlertFormDataState dataState}) {
    return DropdownWidget<GetIncidentIndicationData>(
      star: AppString.star,
      label: AppString.incidentIndication,
      hint: AppString.incidentIndication,
      dropdownValue: dataState.incidentIndicationValue.id == null ? null : dataState.incidentIndicationValue,
      items: dataState.listOfIncidentIndication,
      onChanged: (val) {
        BlocProvider.of<CreateAlertFormBloc>(context)
            .add(SelectIncidentIndicationValueEvent(incidentIndicationValue: val!,context: context));
      },
    );
  }

  Widget _assetsDropdown({required FetchCreateAlertFormDataState dataState}) {
    return  DropdownWidget<GetAssetData>(
      star: AppString.star,
      label: AppString.assets,
      hint: AppString.assets,
      dropdownValue: dataState.assetValue.assetId!.isEmpty ? null : dataState.assetValue,
      items: dataState.listOfAsset,
      onChanged: (val) {
        BlocProvider.of<CreateAlertFormBloc>(context)
            .add(SelectAssetValueEvent(assetValue: val!,context: context));
      },
    );
  }

  Widget _assetIdController({required FetchCreateAlertFormDataState dataState}) {
    return  TextFieldWidget(
        star: AppString.star,
        label: AppString.assets,
        hintText: AppString.assets,
        controller:dataState.assetIdController
    );
  }

  Widget _assetTypeIdController({required FetchCreateAlertFormDataState dataState}){
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.assetTypeId,
        hintText: AppString.assetTypeId,
        controller:dataState.tfGisIdController
    );
  }

  Widget _addressController({required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.address,
        hintText: AppString.address,
        controller:dataState.addressController
    );
  }



  Widget _landmarkController({required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.landmark,
        hintText: AppString.landmark,
        controller:dataState.landmarkController
    );
  }




  Widget _descriptionController({required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
      //   star: AppString.star,
        label: AppString.description,
        hintText: AppString.description,
        controller:dataState.descriptionController
    );
  }

  Widget _remarksController({required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
      //   star: AppString.star,
        label: AppString.remarks,
        hintText: AppString.remarks,
        controller:dataState.remarksController
    );
  }

  Widget _image({required FetchCreateAlertFormDataState dataState}){
    return Row(

      children: [
        ImageWidget(
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
                      BlocProvider.of<CreateAlertFormBloc>(context).add(CaptureCameraPhotoEvent());
                    },
                    onTapGallery: () async {
                      Navigator.of(context).pop();
                      BlocProvider.of<CreateAlertFormBloc>(context).add(CaptureGalleryPhotoEvent());
                    },
                  );
                });
          },
        ),
        SizedBox(width: 12,),
        IconButton(
          onPressed: () async {
            double size =  MediaQuery.of(!context.mounted ? context : context).size.height
                - MediaQuery.of(!context.mounted ? context : context).size.width;
            var res = await showCupertinoModalPopup<dynamic>(
              context: !context.mounted ? context : context,
              builder: (BuildContext context) => Container(
                height: size * 0.70,
                padding: const EdgeInsets.only(top: 6.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const SafeArea(
                  top: false,
                  child: VoiceRecordWidget(),
                ),
              ),
            );
            if(res != null){
              BlocProvider.of<CreateAlertFormBloc>(!context.mounted ? context : context,)
                  .add(SelectAudioEvent(audioPath: res.toString()));
            }
          }, icon: Icon(Icons.mic, color: dataState.audioRecordFile.path.isNotEmpty ? AppColor.primer :AppColor.grey,),
          style: IconButton.styleFrom(backgroundColor: AppColor.primer),
        ),
      /*  CircleAvatar(
            backgroundColor: AppColor.primer,
            child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.mic,color: AppColor.white,size: 18,))))*/
      ],
    );
  }

  Widget _button({required FetchCreateAlertFormDataState dataState}) {
    return dataState.isBtnLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<CreateAlertFormBloc>(context).add(SubmitAddIncidentBtnEvent(context: context));
        })
        : DottedLoaderWidget();
  }
}