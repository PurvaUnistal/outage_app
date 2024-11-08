import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:igl_outage_app/Utils/common_widgets/GetImage/get_image_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_event.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/bloc/create_alert_form_state.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAreaModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetAssetModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetChargeAreaModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetControlRoomModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetCustomerLocationModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentIndicationModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetIncidentTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetLocationSourceModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetModuleTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/domain/model/GetPriorityTypeModel.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/helper/create_alert_form_helper.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/helper/create_alert_form_http_helper.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';

class CreateAlertFormBloc
    extends Bloc<CreateAlertFormEvent, CreateAlertFormState> {
  CreateAlertFormBloc() : super(CreateAlertFormInitialState()) {
    on<CreateAlertFormLoadEvent>(_pageLoad);
    on<SelectModuleValueEvent>(_selectModuleValue);
    on<SelectIncidentTypeValueEvent>(_selectIncidentTypeValue);
    on<SelectPriorityTypeValueEvent>(_selectPriorityTypeValue);
    on<SelectLocationSourceValueEvent>(_selectLocationSourceValue);
    on<SelectInformationSourceValueEvent>(_selectInformationSourceValue);
    on<SelectIncidentIndicationValueEvent>(_selectIncidentIndicationValue);
    on<SelectChargeAreaValueEvent>(_selectChargeAreaValue);
    on<SelectAreaValueEvent>(_selectAreaValue);
    on<SelectControlRoomValueEvent>(_selectControlRoomValue);
    on<SelectCustomerTypeValueEvent>(_selectCustomerTypeValue);
    on<SelectSearchNumberControllerEvent>(_selectSearchNumberController);
    on<SelectAssetValueEvent>(_selectAssetValue);
    on<SelectAssetTypeIdValueEvent>(_selectAssetTypeIdValue);
    on<CaptureCameraPhotoEvent>(_captureCameraPhoto);
    on<CaptureGalleryPhotoEvent>(_captureGalleryPhoto);
    on<SubmitAddIncidentBtnEvent>(_submitBtn);
  }

  File photo = File('');
  bool isLoader = false;
  bool isBtnLoader = false;
  bool isModuleLoader = false;
  bool isChargeAreaLoader = false;
  bool isAreaLoader = false;
  bool isCustomerTypeLoader = false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';

  TextEditingController tfGisIdController = TextEditingController();
  TextEditingController valveGisIdController = TextEditingController();
  TextEditingController markerLatitudeController = TextEditingController();
  TextEditingController markerLongitudeController = TextEditingController();
  TextEditingController currentLatitudeController = TextEditingController();
  TextEditingController currentLongitudeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController searchNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController infoSecurityNameController = TextEditingController();
  TextEditingController infoSecurityIdController = TextEditingController();
  TextEditingController infoSecurityMobileController = TextEditingController();
  TextEditingController infoCustomerNameController = TextEditingController();
  TextEditingController infoCustomerBpNumberController =
      TextEditingController();
  TextEditingController infoCustomerMobileController = TextEditingController();
  TextEditingController infoOtherNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  GetModuleTypeModel moduleTypeModel = GetModuleTypeModel();
  GetModuleTypeData moduleTypeValue = GetModuleTypeData();
  List<GetModuleTypeData> listOfModuleType = [];

  GetIncidentTypeModel incidentTypeModel = GetIncidentTypeModel();
  GetIncidentTypeData incidentTypeValue = GetIncidentTypeData();
  List<GetIncidentTypeData> listOfIncidentType = [];

  GetPriorityTypeModel priorityTypeModel = GetPriorityTypeModel();
  GetPriorityTypeData priorityTypeValue = GetPriorityTypeData();
  List<GetPriorityTypeData> listOfPriorityType = [];

  GetLocationSourceModel locationSourceModel = GetLocationSourceModel();
  GetLocationSourceModel locationSourceValue = GetLocationSourceModel();
  List<GetLocationSourceModel> listOfLocationSource = [];

  GetPriorityTypeModel informationSourceModel = GetPriorityTypeModel();
  GetPriorityTypeData informationSourceValue = GetPriorityTypeData();
  List<GetPriorityTypeData> listOfInformationSource = [];

  GetIncidentIndicationModel incidentIndicationModel =
      GetIncidentIndicationModel();
  GetIncidentIndicationData incidentIndicationValue =
      GetIncidentIndicationData();
  List<GetIncidentIndicationData> listOfIncidentIndication = [];

  GetChargeAreaModel chargeAreaValue = GetChargeAreaModel();
  List<GetChargeAreaModel> listOfChargeArea = [];

  GetAreaModel areaValue = GetAreaModel();
  List<GetAreaModel> listOfArea = [];

  GetLocationSourceModel customerTypeValue = GetLocationSourceModel();
  List<GetLocationSourceModel> listOfCustomerType = [];

  GetAssetModel assetModel = GetAssetModel();
  GetAssetData assetDataValue = GetAssetData();
  List<GetAssetData> listOfAssetData = [];

  GetTfGisModel gasValueGISModel = GetTfGisModel();
  TfGisData assetTypeIdValue = TfGisData();
  List<TfGisData> listOfAssetTypeId = [];

  GetCustomerLocationModel customerLocationModel = GetCustomerLocationModel();
  GetCustomerLocationData getCustomerLocationData = GetCustomerLocationData();
  List<GetCustomerLocationData> listOfCustomerLocationData = [];
  List<String> listOfSearchNumber = [];

  GetControlRoomModel controlRoomModel = GetControlRoomModel();
  GetControlRoomData controlRoomValue = GetControlRoomData();
  List<GetControlRoomData> listOfControlRoom = [];

  _pageLoad(CreateAlertFormLoadEvent event, emit) async {
    emit(CreateAlertFormInitialState());
    photo = File('');
    isLoader = false;
    isBtnLoader = false;
    isModuleLoader = false;
    isChargeAreaLoader = false;
    isAreaLoader = false;
    isCustomerTypeLoader = false;
    moduleTypeModel = GetModuleTypeModel();
    moduleTypeValue = GetModuleTypeData();
    listOfModuleType = [];
    incidentTypeModel = GetIncidentTypeModel();
    incidentTypeValue = GetIncidentTypeData();
    listOfIncidentType = [];
    priorityTypeModel = GetPriorityTypeModel();
    priorityTypeValue = GetPriorityTypeData();
    listOfPriorityType = [];
    locationSourceModel = GetLocationSourceModel();
    locationSourceValue = GetLocationSourceModel();
    listOfLocationSource = [];
    informationSourceModel = GetPriorityTypeModel();
    informationSourceValue = GetPriorityTypeData();
    listOfInformationSource = [];
    incidentIndicationModel = GetIncidentIndicationModel();
    incidentIndicationValue = GetIncidentIndicationData();
    listOfIncidentIndication = [];
    chargeAreaValue = GetChargeAreaModel();
    listOfChargeArea = [];
    areaValue = GetAreaModel();
    listOfArea = [];
    customerTypeValue = GetLocationSourceModel();
    listOfCustomerType = [];
    assetModel = GetAssetModel();
    assetDataValue = GetAssetData();
    listOfAssetData = [];

    gasValueGISModel = GetTfGisModel();
    assetTypeIdValue = TfGisData();
    listOfAssetTypeId = [];

    customerLocationModel = GetCustomerLocationModel();
    getCustomerLocationData = GetCustomerLocationData();
    listOfCustomerLocationData = [];
    listOfSearchNumber = [];
    controlRoomModel = GetControlRoomModel();
    controlRoomValue = GetControlRoomData();
    listOfControlRoom = [];
    currentLatitudeController.text = "";
    currentLongitudeController.text = "";
    addressController.text = "";
    landmarkController.text = "";
    searchNumberController.text = "";
    locationController.text = "";
    infoSecurityNameController.text = "";
    infoSecurityIdController.text = "";
    infoSecurityMobileController.text = "";
    infoCustomerNameController.text = "";
    infoCustomerBpNumberController.text = "";
    infoCustomerMobileController.text = "";
    infoOtherNameController.text = "";
    descriptionController.text = "";
    remarksController.text = "";
    markerLatitudeController.text =
        await SharedPref.getString(key: PrefsValue.markerLat);
    tfGisIdController.text = await SharedPref.getString(key: PrefsValue.tfGisId);
    valveGisIdController.text = await SharedPref.getString(key: PrefsValue.gasValveGISId);
    markerLongitudeController.text =
        await SharedPref.getString(key: PrefsValue.markerLong);
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await _getCurrentPosition();
    await _fetchIncidentIndicationApi(context: event.context);
    await _fetchIncidentTypeApi(context: event.context, moduleId: "");
    _eventCompleted(emit);
  }

  _getCurrentPosition() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    currentLatitudeController.text = currentPoint!.latitude.toString();
    currentLongitudeController.text = currentPoint.longitude.toString();
  }

  _fetchOutageModuleApi({required BuildContext context}) async {
    var res = await CreateAlertFormHelper.getOutageModuleApi(context: context);
    if (res != null) {
      moduleTypeModel = res;
      if (moduleTypeModel.data != null) {
        listOfModuleType = moduleTypeModel.data!;
      }
      return res;
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

  _fetchIncidentPriorityApi(
      {required BuildContext context, required String moduleId}) async {
    var res = await CreateAlertFormHelper.getIncidentPriorityApi(
        context: context, moduleId: moduleId);
    if (res != null) {
      priorityTypeModel = res;
      if (priorityTypeModel.data != null) {
        listOfPriorityType = priorityTypeModel.data!;
      }
      return res;
    }
  }

  _fetchLocationSourceApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getLocationSourceApi(
      context: context,
    );
    if (res != null) {
      listOfLocationSource = res;
    }
    return res;
  }

  _fetchCustomerLocationSourceApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getCustomerLocationSourceApi(
      context: context,
    );
    if (res != null) {
      listOfCustomerType = res;
    }
    return res;
  }

  _fetchInformationSourceApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHelper.getInformationSourceApi(
      context: context,
    );
    if (res != null) {
      informationSourceModel = res;
      if (informationSourceModel.data != null) {
        listOfInformationSource = informationSourceModel.data!;
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

  _fetchChargeAreaListApi({
    required BuildContext context,
  }) async {
    var res = await CreateAlertFormHttpHelper.getChargeAreaListApi(
      context: context,
    );
    if (res != null) {
      listOfChargeArea = res;
    }
    return res;
  }

  _fetchAllAreaApi({required BuildContext context, required String gid}) async {
    var res = await CreateAlertFormHttpHelper.getAllAreaApi(
        context: context, gid: gid);
    if (res != null) {
      listOfArea = res;
    }
    return res;
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
        listOfAssetData = assetModel.data!;
      }
      return res;
    }
  }

  _fetchGasValueGisApi({
    required BuildContext context,
  }) async {
    var res = await ReportAlertHelper.getGasValueGisApi(
      context: context,
    );
    if (res != null) {
      gasValueGISModel = res;
      if (gasValueGISModel.data != null) {
        listOfAssetTypeId = gasValueGISModel.data!;
        return res;
      }
    }
  }

  _fetchCustomerDetailByLocationApi(
      {required BuildContext context,
      required String locationSource,
      required String search}) async {
    listOfCustomerLocationData = [];
    var res = await CreateAlertFormHelper.getCustomerDetailByLocationApi(
        context: context, locationSource: locationSource, search: search);
    if (res != null) {
      customerLocationModel = res;
      if (customerLocationModel.data != null) {
        listOfCustomerLocationData = customerLocationModel.data!;
        if (customerTypeValue.key == "1") {
          listOfSearchNumber =
              listOfCustomerLocationData.map((e) => e.bpNumber!).toList();
        } else if (customerTypeValue.key == "2") {
          listOfSearchNumber =
              listOfCustomerLocationData.map((e) => e.mobileNumber!).toList();
        } else if (customerTypeValue.key == "3") {
          listOfSearchNumber =
              listOfCustomerLocationData.map((e) => e.serialNumber!).toList();
        } else {
          listOfSearchNumber =
              listOfCustomerLocationData.map((e) => e.bpNumber!).toList();
        }
      }
      return res;
    }
  }

  _fetchControlRoomApi(
      {required BuildContext context, required String areaId}) async {
    listOfCustomerLocationData = [];
    var res = await CreateAlertFormHelper.getControlRoomApi(
      context: context,
      areaId: areaId,
    );
    if (res != null) {
      controlRoomModel = res;
      if (controlRoomModel.data != null) {
        listOfControlRoom = controlRoomModel.data!;
      }
      return res;
    }
  }

  _selectModuleValue(
      SelectModuleValueEvent event, Emitter<CreateAlertFormState> emit) async {
    incidentTypeModel = GetIncidentTypeModel();
    incidentTypeValue = GetIncidentTypeData();
    listOfIncidentType = [];
    priorityTypeModel = GetPriorityTypeModel();
    priorityTypeValue = GetPriorityTypeData();
    listOfPriorityType = [];
    moduleTypeValue = event.moduleTypeValue;
    if (event.moduleTypeValue.id != null) {
      isModuleLoader = true;
      _eventCompleted(emit);
      await _fetchIncidentTypeApi(
          context: event.context, moduleId: event.moduleTypeValue.id!);
      await _fetchIncidentPriorityApi(
          context: event.context, moduleId: event.moduleTypeValue.id!);
      isModuleLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectIncidentTypeValue(SelectIncidentTypeValueEvent event, emit) {
    incidentTypeValue = event.incidentTypeValue;
    _eventCompleted(emit);
  }

  _selectPriorityTypeValue(SelectPriorityTypeValueEvent event, emit) {
    priorityTypeValue = event.priorityTypeValue;
    _eventCompleted(emit);
  }

  _selectLocationSourceValue(SelectLocationSourceValueEvent event, emit) {
    addressController.text = "";
    searchNumberController.text = "";
    assetDataValue = GetAssetData();
    assetTypeIdValue = TfGisData();
    customerTypeValue = GetLocationSourceModel();
    locationSourceValue = event.locationSourceValue;
    _eventCompleted(emit);
  }

  _selectInformationSourceValue(SelectInformationSourceValueEvent event, emit) {
    informationSourceValue = event.informationSourceValue;
    _eventCompleted(emit);
  }

  _selectIncidentIndicationValue(
      SelectIncidentIndicationValueEvent event, emit) {
    incidentIndicationValue = event.incidentIndicationValue;
    _eventCompleted(emit);
  }

  _selectChargeAreaValue(SelectChargeAreaValueEvent event, emit) async {
    areaValue = GetAreaModel();
    listOfArea = [];
    chargeAreaValue = event.chargeAreaValue;
    if (chargeAreaValue.gid != null) {
      isChargeAreaLoader = true;
      _eventCompleted(emit);
      await _fetchAllAreaApi(
          context: event.context, gid: event.chargeAreaValue.gid!);
      isChargeAreaLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectAreaValue(SelectAreaValueEvent event, emit) async {
    controlRoomValue = GetControlRoomData();
    listOfControlRoom = [];
    areaValue = event.areaValue;
    if (areaValue.gid != null) {
      isAreaLoader = true;
      _eventCompleted(emit);
      await _fetchControlRoomApi(
          context: event.context, areaId: areaValue.gid ?? "");
      isAreaLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectControlRoomValue(SelectControlRoomValueEvent event, emit) {
    controlRoomValue = event.controlRoomValue;
    _eventCompleted(emit);
  }

  _selectCustomerTypeValue(SelectCustomerTypeValueEvent event, emit) async {
    searchNumberController.text = '';
    listOfSearchNumber = [];
    customerTypeValue = event.customerTypeValue;
    if (customerTypeValue.key != null) {
      isCustomerTypeLoader = true;
      _eventCompleted(emit);

      await _fetchCustomerDetailByLocationApi(
        context: event.context,
        search: searchNumberController.text.trim().toString(),
        locationSource: customerTypeValue.key!,
      );
    }
    isCustomerTypeLoader = false;
    _eventCompleted(emit);
  }

  _selectSearchNumberController(SelectSearchNumberControllerEvent event, emit) {
    searchNumberController.text = event.searchNumberValue;
    if (customerTypeValue.key == "1") {
      searchNumberController.text = listOfCustomerLocationData
              .firstWhereOrNull(
                  (element) => element.bpNumber == event.searchNumberValue)
              ?.bpNumber ??
          "";
    } else if (customerTypeValue.key == "2") {
      searchNumberController.text = listOfCustomerLocationData
              .firstWhereOrNull(
                  (element) => element.mobileNumber == event.searchNumberValue)
              ?.mobileNumber ??
          "";
    } else if (customerTypeValue.key == "3") {
      searchNumberController.text = listOfCustomerLocationData
              .firstWhereOrNull(
                  (element) => element.serialNumber == event.searchNumberValue)
              ?.serialNumber ??
          "";
    } else {
      searchNumberController.text = listOfCustomerLocationData
              .firstWhereOrNull(
                  (element) => element.bpNumber == event.searchNumberValue)
              ?.bpNumber ??
          "";
    }
    _eventCompleted(emit);
  }

  _selectAssetValue(SelectAssetValueEvent event, emit) {
    assetDataValue = event.assetDataValue;
    _eventCompleted(emit);
  }

  _selectAssetTypeIdValue(SelectAssetTypeIdValueEvent event, emit) {
    assetTypeIdValue = event.assetTypeIdValue;
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

  _submitBtn(SubmitAddIncidentBtnEvent event, emit) async {
    //  try{
    var validationCheck = await CreateAlertFormHelper.validationSubmit(
        context: event.context,
        moduleType: moduleTypeValue,
        incidentType: incidentTypeValue,
        incidentPriority: priorityTypeValue,
        locationSource: locationSourceValue,
        customerType: customerTypeValue,
        customerSearchNumber: searchNumberController.text.trim().toString(),
        customerAsset: assetDataValue,
        assetInternalId: assetTypeIdValue,
        customerLocation: locationController.text.trim().toString(),
        infoSource: informationSourceValue,
        infoSecurityName: infoSecurityNameController.text.trim().toString(),
        infoSecurityId: infoSecurityIdController.text.trim().toString(),
        infoSecurityMobile: infoSecurityMobileController.text.trim().toString(),
        infoCustName: infoCustomerNameController.text.trim().toString(),
        infoCustBpNumber: infoCustomerBpNumberController.text.trim().toString(),
        infoCustMobile: infoCustomerMobileController.text.trim().toString(),
        infoOtherName: infoOtherNameController.text.trim().toString(),
        address: addressController.text.trim().toString(),
        landmark: landmarkController.text.trim().toString(),
        incidentIndication: incidentIndicationValue,
        chargeArea: chargeAreaValue,
        area: areaValue,
        controlRoom: controlRoomValue,
        photo: photo);
    if (await validationCheck == true) {
      isBtnLoader = false;
      _eventCompleted(emit);
      var res = await CreateAlertFormHelper.addIncidentData(
        context: event.context,
        moduleType: moduleTypeValue,
        incidentType: incidentTypeValue,
        incidentPriority: priorityTypeValue,
        locationSource: locationSourceValue,
        customerType: customerTypeValue,
        customerSearchNumber: searchNumberController.text.trim().toString(),
        customerAsset: assetDataValue,
        assetInternalId: assetTypeIdValue,
        customerLocation: locationController.text.trim().toString(),
        infoSource: informationSourceValue,
        infoSecurityName: infoSecurityNameController.text.trim().toString(),
        infoSecurityId: infoSecurityIdController.text.trim().toString(),
        infoSecurityMobile: infoSecurityMobileController.text.trim().toString(),
        infoCustName: infoCustomerNameController.text.trim().toString(),
        infoCustBpNumber: infoCustomerBpNumberController.text.trim().toString(),
        infoCustMobile: infoCustomerMobileController.text.trim().toString(),
        infoOtherName: infoOtherNameController.text.trim().toString(),
        address: addressController.text.trim().toString(),
        landmark: landmarkController.text.trim().toString(),
        incidentIndication: incidentIndicationValue,
        chargeArea: chargeAreaValue,
        area: areaValue,
        controlRoom: controlRoomValue,
        photo: photo,
        currentLat: currentLatitudeController.text.trim().toString(),
        currentLong: currentLongitudeController.text.trim().toString(),
        markerLat: markerLatitudeController.text.trim().toString(),
        markerLong: markerLongitudeController.text.trim().toString(),
        remarks: remarksController.text.trim().toString(),
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
      isLoader: isLoader,
      isBtnLoader: isBtnLoader,
      isChargeAreaLoader: isChargeAreaLoader,
      isAreaLoader: isAreaLoader,
      isModuleLoader: isModuleLoader,
      isCustomerTypeLoader: isCustomerTypeLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
      moduleTypeModel: moduleTypeModel,
      moduleTypeValue: moduleTypeValue,
      listOfModuleType: listOfModuleType,
      incidentTypeModel: incidentTypeModel,
      incidentTypeValue: incidentTypeValue,
      listOfIncidentType: listOfIncidentType,
      priorityTypeModel: priorityTypeModel,
      priorityTypeValue: priorityTypeValue,
      listOfPriorityType: listOfPriorityType,
      locationSourceModel: locationSourceModel,
      locationSourceValue: locationSourceValue,
      listOfLocationSource: listOfLocationSource,
      informationSourceModel: informationSourceModel,
      informationSourceValue: informationSourceValue,
      listOfInformationSource: listOfInformationSource,
      incidentIndicationModel: incidentIndicationModel,
      incidentIndicationValue: incidentIndicationValue,
      listOfIncidentIndication: listOfIncidentIndication,
      listOfSearchNumber: listOfSearchNumber,
      chargeAreaValue: chargeAreaValue,
      listOfChargeArea: listOfChargeArea,
      areaValue: areaValue,
      listOfArea: listOfArea,
      customerTypeValue: customerTypeValue,
      listOfCustomerType: listOfCustomerType,
      assetModel: assetModel,
      assetDataValue: assetDataValue,
      listOfAssetData: listOfAssetData,
      assetTypeIdValue: assetTypeIdValue,
      listOfAssetTypeId: listOfAssetTypeId,
      controlRoomModel: controlRoomModel,
      controlRoomValue: controlRoomValue,
      listOfControlRoom: listOfControlRoom,
      tfGisIdController: tfGisIdController,
      valveGisIdController: valveGisIdController,
      markerLatitudeController: markerLatitudeController,
      markerLongitudeController: markerLongitudeController,
      currentLatitudeController: currentLatitudeController,
      currentLongitudeController: currentLongitudeController,
      addressController: addressController,
      landmarkController: landmarkController,
      searchNumberController: searchNumberController,
      locationController: locationController,
      infoSecurityNameController: infoSecurityNameController,
      infoSecurityIdController: infoSecurityIdController,
      infoSecurityMobileController: infoSecurityMobileController,
      infoCustomerNameController: infoCustomerNameController,
      infoCustomerBpNumberController: infoCustomerBpNumberController,
      infoCustomerMobileController: infoCustomerMobileController,
      infoOtherNameController: infoOtherNameController,
      descriptionController: descriptionController,
      remarksController: remarksController,
    ));
  }
}
