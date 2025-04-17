import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/GetImage/get_image_widget.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_event.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/bloc/create_alert_form_state.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/model/GetAssetModel.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:outage_app/features/Report/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:outage_app/features/Report/CreateAlertForm/helper/create_alert_form_helper.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/report_alert_helper.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';

class CreateAlertFormBloc
    extends Bloc<CreateAlertFormEvent, CreateAlertFormState> {
  CreateAlertFormBloc() : super(CreateAlertFormInitialState()) {
    on<CreateAlertFormLoadEvent>(_pageLoad);
    on<SelectIncidentTypeValueEvent>(_selectIncidentTypeValue);
    on<SelectIncidentIndicationValueEvent>(_selectIncidentIndicationValue);
    on<SelectAssetValueEvent>(_selectAssetValue);
    on<SelectTfGisValueEvent>(_selectTfGisValue);
    on<CaptureCameraPhotoEvent>(_captureCameraPhoto);
    on<CaptureGalleryPhotoEvent>(_captureGalleryPhoto);
    on<SelectAudioEvent>(_selectAudio);
    on<SubmitAddIncidentBtnEvent>(_submitBtn);
  }

  File photo = File('');
  File audioRecordFile = File("");
  bool isLoader = false;
  bool isBtnLoader = false;


  String role = '';
  String baseUrl = '';
  String assetId = '';
  String locationSource = '';

  TextEditingController assetIdController = TextEditingController();
  TextEditingController assetTypeIdController = TextEditingController();
  TextEditingController tfGisIdController = TextEditingController();
  TextEditingController valveGisIdController = TextEditingController();
  TextEditingController markerLatitudeController = TextEditingController();
  TextEditingController markerLongitudeController = TextEditingController();
  TextEditingController currentLatitudeController = TextEditingController();
  TextEditingController currentLongitudeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  GetIncidentTypeModel incidentTypeModel = GetIncidentTypeModel();
  GetIncidentTypeData incidentTypeValue = GetIncidentTypeData();
  List<GetIncidentTypeData> listOfIncidentType = [];

  GetIncidentIndicationModel incidentIndicationModel =
      GetIncidentIndicationModel();
  GetIncidentIndicationData incidentIndicationValue =
      GetIncidentIndicationData();
  List<GetIncidentIndicationData> listOfIncidentIndication = [];

  GetAssetModel assetModel = GetAssetModel();
  GetAssetData assetValue = GetAssetData();
  List<GetAssetData> listOfAsset = [];
  List<GetAssetData> listOfFilterAsset = [];

  GasGisData tfGisValue = GasGisData();
  List<GasGisData> listOfTfGis = [];

  GasGisData valveGisValue = GasGisData();
  List<GasGisData> listOfValveGis = [];

  _pageLoad(CreateAlertFormLoadEvent event, emit) async {
    emit(CreateAlertFormInitialState());
    photo = File('');
    audioRecordFile = File("");
    isLoader = false;
    isBtnLoader = false;
    locationSource = "";
    print(
        "AppConfig.instanceInit()?.assets--->${AppConfig.instanceInit()?.assets}"); // Output: active
    print(
        "AppConfig.instanceInit()?.assetsTypeId--->${AppConfig.instanceInit()?.assetsTypeId}"); // Output: active
    incidentTypeModel = GetIncidentTypeModel();
    incidentTypeValue = GetIncidentTypeData();
    listOfIncidentType = [];

    incidentIndicationModel = GetIncidentIndicationModel();
    incidentIndicationValue = GetIncidentIndicationData();
    listOfIncidentIndication = [];

    assetModel = GetAssetModel();
    assetValue = GetAssetData();
    listOfAsset = [];
    listOfFilterAsset = [];

    tfGisValue = GasGisData();
    listOfTfGis = [];

    valveGisValue = GasGisData();
    listOfValveGis = [];

    assetTypeIdController.text = "";
    currentLatitudeController.text = "";
    currentLongitudeController.text = "";
    addressController.text = "";
    landmarkController.text = "";
    descriptionController.text = "";
    remarksController.text = "";
    assetId = "";
    assetTypeIdController.text = "";
    await ReportAlertHelper.clearCache();
    assetId = (await AppConfig.instanceInit()?.assets) ?? "";
    assetTypeIdController.text =
        (await AppConfig.instanceInit()?.assetsTypeId) ?? "";
    markerLatitudeController.text =
        await AppConfig.instanceInit()?.markerLat ?? "";
    markerLongitudeController.text =
        await AppConfig.instanceInit()?.markerLong ?? "";
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);

    await Future.wait(<Future>[
      _getCurrentPosition(),
      _fetchIncidentIndicationApi(context: event.context),
      _fetchIncidentTypeApi(context: event.context, moduleId: ""),
      _fetchAssetLocationSourceApi(
        context: event.context,
      ),
    ]);

    /*await _fetchIncidentIndicationApi(context: event.context);
    await _fetchIncidentTypeApi(context: event.context, moduleId: "");
    await _fetchAssetLocationSourceApi(
      context: event.context,
    );*/
    _eventCompleted(emit);
  }

  _getCurrentPosition() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    if (currentPoint != null) {
      currentLatitudeController.text = currentPoint.latitude.toString();
      currentLongitudeController.text = currentPoint.longitude.toString();
    }
  }

  _fetchIncidentTypeApi(
      {required BuildContext context, required String moduleId}) async {
    var res = await CreateAlertFormHelper.getIncidentTypeApi(
        context: context, moduleId: moduleId);
    if (res != null) {
      incidentTypeModel = res;
      if (incidentTypeModel.data != null) {
        listOfIncidentType = incidentTypeModel.data!;
      }
      return res;
    }
  }

  _fetchIncidentIndicationApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getIncidentIndicationApi(
      context: context,
    );
    if (res != null) {
      incidentIndicationModel = res;
      if (incidentIndicationModel.data != null) {
        listOfIncidentIndication = incidentIndicationModel.data!;
      }
      return res;
    }
  }

  Future _fetchAssetLocationSourceApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getAssetLocationSourceApi(
      context: context,
    );
    if (res != null) {
      assetModel = res;
      if (assetModel.data != null) {
        listOfAsset = assetModel.data!;
        print("assetId--->$assetId");
        print("assetTypeIdController--->${assetTypeIdController.text}");
        if (assetId != '') {
          listOfFilterAsset = listOfAsset
              .where((assetIdData) => assetId == assetIdData.id)
              .toList();
          if (listOfFilterAsset.isNotEmpty) {
            assetIdController.text = listOfFilterAsset[0].assetName!;
            locationSource = "1";
          } else if (assetId == "0") {
            assetIdController.text = "Consumer";
            locationSource = "2";
          } else {
            assetIdController.text = "";
          }
        } else {
          assetIdController.text = "";
          assetTypeIdController.text = "";
        }
        return res;
      }
    }
  }

  _selectIncidentTypeValue(SelectIncidentTypeValueEvent event, emit) {
    incidentTypeValue = event.incidentTypeValue;
    _eventCompleted(emit);
  }

  _selectIncidentIndicationValue(
      SelectIncidentIndicationValueEvent event, emit) {
    incidentIndicationValue = event.incidentIndicationValue;
    _eventCompleted(emit);
  }

  _selectAssetValue(SelectAssetValueEvent event, emit) {
    assetValue = event.assetValue;
    _eventCompleted(emit);
  }

  _selectTfGisValue(SelectTfGisValueEvent event, emit) {
    tfGisValue = event.tfGisValue;
    _eventCompleted(emit);
  }

  _captureCameraPhoto(CaptureCameraPhotoEvent event, emit) async {
    var photoPath = await GetImageWidget.cameraCapture();
    log("photo-->$photoPath");
    if (photoPath?.path != null) {
      photo = photoPath!;
    }
    _eventCompleted(emit);
  }

  _captureGalleryPhoto(CaptureGalleryPhotoEvent event, emit) async {
    var photoPath = await GetImageWidget.galleryCapture();
    log("photo-->$photoPath");
    if (photoPath.path.isNotEmpty) {
      photo = photoPath;
    }
    _eventCompleted(emit);
  }

  _selectAudio(SelectAudioEvent event, emit) {
    audioRecordFile = File(event.audioPath);
    _eventCompleted(emit);
  }

  _submitBtn(SubmitAddIncidentBtnEvent event, emit) async {
    try {
      var validationCheck = await CreateAlertFormHelper.validationSubmit(
          context: event.context,
          incidentType: incidentTypeValue,
          incidentIndication: incidentIndicationValue,
          assetTypeId: assetIdController.text.trim().toString(),
          assetId: assetId.toString(),
          address: addressController.text.trim().toString(),
          landmark: landmarkController.text.trim().toString(),
          photo: photo);
      if (await validationCheck == true) {
        isBtnLoader = false;
        _eventCompleted(emit);
        var res = await CreateAlertFormHelper.addIncidentData(
          context: event.context,
          incidentType: incidentTypeValue,
          incidentIndication: incidentIndicationValue,
          locationSource: locationSource,
          customeId: locationSource == "2"
              ? assetTypeIdController.text.trim().toString()
              : "",
          assetTypeId: assetId.toString(),
          assetInternalId: locationSource == "1"
              ? assetTypeIdController.text.trim().toString()
              : "",
          address: addressController.text.trim().toString(),
          landmark: landmarkController.text.trim().toString(),
          photo: photo,
          currentLat: currentLatitudeController.text.trim().toString(),
          currentLong: currentLongitudeController.text.trim().toString(),
          markerLat: markerLatitudeController.text.trim().toString(),
          markerLong: markerLongitudeController.text.trim().toString(),
          description: descriptionController.text.trim().toString(),
          incidentVoice: audioRecordFile.path.toString(),
        );
        if (res != null) {
          isBtnLoader = false;
          _eventCompleted(emit);
          Utils.successSnackBar(msg: res.data!, context: event.context);
          Navigator.pushReplacementNamed(
            event.context,
            RoutesName.outageApp,
          );
        } else {
          isBtnLoader = false;
          _eventCompleted(emit);
        }
      }
    } catch (e) {
      isBtnLoader = false;
      log("submit--->${e.toString()}");
      _eventCompleted(emit);
    }
  }

  _eventCompleted(Emitter<CreateAlertFormState> emit) {
    emit(FetchCreateAlertFormDataState(
      photo: photo,
      audioRecordFile: audioRecordFile,
      isLoader: isLoader,
      isBtnLoader: isBtnLoader,
      baseUrl: baseUrl,
      role: role,
      incidentTypeModel: incidentTypeModel,
      incidentTypeValue: incidentTypeValue,
      listOfIncidentType: listOfIncidentType,
      incidentIndicationModel: incidentIndicationModel,
      incidentIndicationValue: incidentIndicationValue,
      listOfIncidentIndication: listOfIncidentIndication,
      assetModel: assetModel,
      assetValue: assetValue,
      listOfAsset: listOfAsset,
      listOfTfGis: listOfTfGis,
      tfGisValue: tfGisValue,
      assetTypeIdController: assetTypeIdController,
      assetIdController: assetIdController,
      tfGisIdController: tfGisIdController,
      valveGisIdController: valveGisIdController,
      markerLatitudeController: markerLatitudeController,
      markerLongitudeController: markerLongitudeController,
      currentLatitudeController: currentLatitudeController,
      currentLongitudeController: currentLongitudeController,
      addressController: addressController,
      landmarkController: landmarkController,
      descriptionController: descriptionController,
      remarksController: remarksController,
    ));
  }
}
