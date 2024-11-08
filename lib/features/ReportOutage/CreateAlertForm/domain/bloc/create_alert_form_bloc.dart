import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:igl_outage_app/Utils/common_widgets/GetImage/get_image_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_event.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_state.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAssetModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/helper/create_alert_form_helper.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';

class CreateAlertFormBloc
    extends Bloc<CreateAlertFormEvent, CreateAlertFormState> {
  CreateAlertFormBloc() : super(CreateAlertFormInitialState()) {
    on<CreateAlertFormLoadEvent>(_pageLoad);
    on<SelectIncidentTypeValueEvent>(_selectIncidentTypeValue);
    on<SelectIncidentIndicationValueEvent>(_selectIncidentIndicationValue);
    on<SelectAssetValueEvent>(_selectAssetValue);
    on<CaptureCameraPhotoEvent>(_captureCameraPhoto);
    on<CaptureGalleryPhotoEvent>(_captureGalleryPhoto);
    on<SelectAudioEvent>(_selectAudio);
    on<SubmitAddIncidentBtnEvent>(_submitBtn);
  }

  File photo = File('');
  File audioRecordFile =  File("");
  bool isLoader = false;
  bool isBtnLoader = false;

  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';

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

  GetIncidentIndicationModel incidentIndicationModel = GetIncidentIndicationModel();
  GetIncidentIndicationData incidentIndicationValue = GetIncidentIndicationData();
  List<GetIncidentIndicationData> listOfIncidentIndication = [];

  GetAssetModel assetModel = GetAssetModel();
  GetAssetData assetValue = GetAssetData();
  List<GetAssetData> listOfAsset = [];
  List<GetAssetData> listOfFilterAsset = [];


  _pageLoad(CreateAlertFormLoadEvent event, emit) async {
    emit(CreateAlertFormInitialState());
    photo = File('');
    audioRecordFile =  File("");
    isLoader = false;
    isBtnLoader = false;


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


    currentLatitudeController.text = "";
    currentLongitudeController.text = "";
    addressController.text = "";
    landmarkController.text = "";

    descriptionController.text = "";
    remarksController.text = "";
    assetIdController.text =  await SharedPref.getString(key: PrefsValue.tfAssetId);
    markerLatitudeController.text =
    await SharedPref.getString(key: PrefsValue.markerLat);
    tfGisIdController.text =
    await SharedPref.getString(key: PrefsValue.tfGisId);
    valveGisIdController.text =
    await SharedPref.getString(key: PrefsValue.gasValveGISId);
    markerLongitudeController.text =
    await SharedPref.getString(key: PrefsValue.markerLong);
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await _getCurrentPosition();
    await _fetchIncidentIndicationApi(context: event.context);
    await _fetchIncidentTypeApi(context: event.context, moduleId: "");
   // await _fetchAssetLocationSourceApi(context: event.context,);
    _eventCompleted(emit);
  }

  _getCurrentPosition() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    currentLatitudeController.text = currentPoint!.latitude.toString();
    currentLongitudeController.text = currentPoint.longitude.toString();
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

  _fetchAssetLocationSourceApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getAssetLocationSourceApi(
      context: context,
    );
    if (res != null) {
      assetModel = res;
      if (assetModel.data != null) {
        listOfAsset = assetModel.data!;
        for(var assetIdData in listOfAsset)
          if(assetValue.assetId == assetIdData.assetId){
            listOfFilterAsset.add(assetIdData);
          }
        return res;
      }
    }
  }


  _selectIncidentTypeValue(SelectIncidentTypeValueEvent event, emit) {
    incidentTypeValue = event.incidentTypeValue;
    _eventCompleted(emit);
  }


  _selectIncidentIndicationValue(SelectIncidentIndicationValueEvent event, emit) {
    incidentIndicationValue = event.incidentIndicationValue;
    _eventCompleted(emit);
  }

  _selectAssetValue(SelectAssetValueEvent event, emit) {
    assetValue = event.assetValue;
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
    audioRecordFile =  File(event.audioPath);
    _eventCompleted(emit);
  }

  _submitBtn(SubmitAddIncidentBtnEvent event, emit) async {
    //  try{
    var validationCheck = await CreateAlertFormHelper.validationSubmit(
        context: event.context,
        incidentType: incidentTypeValue,
        incidentIndication: incidentIndicationValue,
        asset: assetIdController.text.trim().toString(),
        assetId: assetIdController.text,
        address: addressController.text.trim().toString(),
        landmark: landmarkController.text.trim().toString(),
        photo: photo
    );
    if (await validationCheck == true) {
      isBtnLoader = false;
      _eventCompleted(emit);
      var res = await CreateAlertFormHelper.addIncidentData(
        context: event.context,
        incidentType: incidentTypeValue,
        incidentIndication: incidentIndicationValue,
        assetId: assetIdController.text.trim().toString(),
        assetInternalId: "",
        address: addressController.text.trim().toString(),
        landmark: landmarkController.text.trim().toString(),
        photo: photo,
        currentLat: currentLatitudeController.text.trim().toString(),
        currentLong: currentLongitudeController.text.trim().toString(),
        markerLat: markerLatitudeController.text.trim().toString(),
        markerLong: markerLongitudeController.text.trim().toString(),
        description: descriptionController.text.trim().toString(),
      );
      if (res != null) {
        isBtnLoader = false;
        _eventCompleted(emit);
        Utils.successSnackBar(msg: res.data!, context: event.context);
        Navigator.pushReplacementNamed(
          event.context,
          RoutesName.home,
        );
      } else {
        isBtnLoader = false;
        _eventCompleted(emit);
      }
    }
    /*}catch(e){
      isBtnLoader = false;
      log("submit--->${e.toString()}");
      _eventCompleted(emit);
    }*/
  }

  _eventCompleted(Emitter<CreateAlertFormState> emit) {
    emit(FetchCreateAlertFormDataState(
      photo: photo,
      audioRecordFile: audioRecordFile,
      isLoader: isLoader,
      isBtnLoader: isBtnLoader,

      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,

      incidentTypeModel: incidentTypeModel,
      incidentTypeValue: incidentTypeValue,
      listOfIncidentType: listOfIncidentType,

      incidentIndicationModel: incidentIndicationModel,
      incidentIndicationValue: incidentIndicationValue,
      listOfIncidentIndication: listOfIncidentIndication,

      assetModel :assetModel,
      assetValue : assetValue,
      listOfAsset : listOfAsset,
      assetTypeIdController: assetTypeIdController,


      assetIdController : assetIdController,
      tfGisIdController : tfGisIdController,
      valveGisIdController : valveGisIdController,
      markerLatitudeController : markerLatitudeController,
      markerLongitudeController : markerLongitudeController,
      currentLatitudeController : currentLatitudeController,
      currentLongitudeController : currentLongitudeController,
      addressController : addressController,
      landmarkController : landmarkController,
      descriptionController : descriptionController,
      remarksController : remarksController,
    ));
  }
}
