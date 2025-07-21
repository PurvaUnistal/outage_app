import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/dropdown_widget.dart';
import 'package:outage_app/Utils/common_widgets/image_pop_widget.dart';
import 'package:outage_app/Utils/common_widgets/image_widget.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/row_widget.dart';
import 'package:outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_bloc.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_event.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_state.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'widget/AudioPlayer.dart';

class CreateAlertFormView extends StatefulWidget {
  const CreateAlertFormView({super.key});

  @override
  State<CreateAlertFormView> createState() => _CreateAlertFormViewState();
}

class _CreateAlertFormViewState extends State<CreateAlertFormView> {
  @override
  void initState() {
    BlocProvider.of<CreateAlertFormBloc>(context)
        .add(CreateAlertFormLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppString.createAlertForm,
          boolLeading: true,
        ),
        body: SafeArea(
          child: BackgroundInfoWidget(
            child: BlocBuilder<CreateAlertFormBloc, CreateAlertFormState>(
              builder: (context, state) {
                if (state is FetchCreateAlertFormDataState) {
                  return _itemBuilder(dataState: state);
                } else {
                  return const Center(child: SpinLoader());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to Create Alert Form?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _itemBuilder({required FetchCreateAlertFormDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: ListView(
        children: [
          CommonStyle.vertical(context: context),
          RowWidget(
              widget1: _currentLatController(dataState: dataState),
              widget2: _currentLongController(dataState: dataState)),
          CommonStyle.vertical(context: context),
          _addressController(dataState: dataState),
          CommonStyle.vertical(context: context),
          /*  _tfValveIdController(dataState: dataState),
          CommonStyle.vertical(context: context),*/

          if (dataState.assetTypeIdController.text.isNotEmpty) ...[
            _assetIdController(dataState: dataState),
            CommonStyle.vertical(context: context),
            _assetTypeIdController(dataState: dataState),
            CommonStyle.vertical(context: context),
          ],
          _incidentTypeDropdown(dataState: dataState),
          CommonStyle.vertical(context: context),
          _incidentIndicationDropdown(dataState: dataState),
          CommonStyle.vertical(context: context),
          _landmarkController(dataState: dataState),
          CommonStyle.vertical(context: context),
          _descriptionController(dataState: dataState),
          CommonStyle.vertical(context: context),
          /*_remarksController(dataState: dataState),
          CommonStyle.vertical(context: context),*/
          _image(dataState: dataState),
          CommonStyle.vertical(context: context),
          CommonStyle.vertical(context: context),
          _button(dataState: dataState),
          CommonStyle.vertical(context: context),
          CommonStyle.vertical(context: context),
        ],
      ),
    );
  }

  Widget _tfValveIdController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: dataState.tfGisIdController.text == ""
            ? AppString.gasValveGisId
            : AppString.gasTfGisId,
        hintText: dataState.tfGisIdController.text == ""
            ? AppString.gasValveGisId
            : AppString.gasTfGisId,
        enabled: false,
        controller: dataState.tfGisIdController.text == ""
            ? dataState.valveGisIdController
            : dataState.tfGisIdController);
  }
  Widget _addressController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.cuAddress,
        hintText: AppString.cuAddress,
        enabled: false,
        controller: dataState.addressController);
  }
  Widget _currentLatController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.currentLat,
        hintText: AppString.currentLat,
        enabled: false,
        controller: dataState.currentLatitudeController);
  }

  Widget _currentLongController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        star: AppString.star,
        label: AppString.currentLong,
        hintText: AppString.currentLong,
        enabled: false,
        controller: dataState.currentLongitudeController);
  }

  Widget _incidentTypeDropdown(
      {required FetchCreateAlertFormDataState dataState}) {
    return DropdownWidget<GetIncidentTypeData>(
      star: AppString.star,
      label: AppString.incidentType,
      hint: AppString.incidentType,
      dropdownValue: dataState.incidentTypeValue.id == null
          ? null
          : dataState.incidentTypeValue,
      items: dataState.listOfIncidentType,
      onChanged: (val) {
        BlocProvider.of<CreateAlertFormBloc>(context).add(
            SelectIncidentTypeValueEvent(
                incidentTypeValue: val!, context: context));
      },
    );
  }

  Widget _incidentIndicationDropdown(
      {required FetchCreateAlertFormDataState dataState}) {
    return DropdownWidget<GetIncidentIndicationData>(
      star: AppString.star,
      label: AppString.incidentIndication,
      hint: AppString.incidentIndication,
      dropdownValue: dataState.incidentIndicationValue.id == null
          ? null
          : dataState.incidentIndicationValue,
      items: dataState.listOfIncidentIndication,
      onChanged: (val) {
        BlocProvider.of<CreateAlertFormBloc>(context).add(
            SelectIncidentIndicationValueEvent(
                incidentIndicationValue: val!, context: context));
      },
    );
  }

  Widget _assetIdController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        label: AppString.assets,
        hintText: AppString.assets,
        enabled: false,
        controller: dataState.assetIdController);
  }

  Widget _assetTypeIdController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
      label: AppString.assetTypeId,
      hintText: AppString.assetTypeId,
      enabled: false,
      controller: dataState.assetTypeIdController,
    );
  }

  Widget _landmarkController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        //  star: AppString.star,
        label: AppString.landmark,
        hintText: AppString.landmark,
        controller: dataState.landmarkController);
  }

  Widget _descriptionController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        //   star: AppString.star,
        label: AppString.description,
        hintText: AppString.description,
        maxLine: 3,
        controller: dataState.descriptionController);
  }

  Widget _remarksController(
      {required FetchCreateAlertFormDataState dataState}) {
    return TextFieldWidget(
        //   star: AppString.star,
        label: AppString.remarks,
        hintText: AppString.remarks,
        controller: dataState.remarksController);
  }

  Widget _image({required FetchCreateAlertFormDataState dataState}) {
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
                      BlocProvider.of<CreateAlertFormBloc>(context)
                          .add(CaptureCameraPhotoEvent());
                    },
                    onTapGallery: () async {
                      Navigator.of(context).pop();
                      BlocProvider.of<CreateAlertFormBloc>(context)
                          .add(CaptureGalleryPhotoEvent());
                    },
                  );
                });
          },
        ),
        SizedBox(
          width: 12,
        ),
        IconButton(
          onPressed: () async {
            double size = MediaQuery.of(!context.mounted ? context : context)
                    .size
                    .height -
                MediaQuery.of(!context.mounted ? context : context).size.width;
            var res = await showCupertinoModalPopup<dynamic>(
                context: !context.mounted ? context : context,
                builder: (BuildContext context) {
                  return Container(
                    height: size * 0.60,
                    child: VoideRecord(
                      audioPath: dataState.audioRecordFile.path,
                    ),
                  );
                });

            if (res != null) {
              BlocProvider.of<CreateAlertFormBloc>(context)
                  .add(SelectAudioEvent(audioPath: res.toString()));
              print("res.toString()---${res.toString()}");
            }
          },
          icon: Icon(
            Icons.mic,
            color: AppColor.white,
          ),
          style: IconButton.styleFrom(backgroundColor:EnvironmentConfig.of(context)!.primaryTheme,),
        ),
      ],
    );
  }

  Widget _button({required FetchCreateAlertFormDataState dataState}) {
    return dataState.isBtnLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<CreateAlertFormBloc>(context)
                  .add(SubmitAddIncidentBtnEvent(context: context));
            })
        : DottedLoaderWidget();
  }
}
