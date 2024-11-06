import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/Utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/GetImage/get_image_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';
import '../../helper/maintenance_alert_helper.dart';
import '../../helper/maintenance_http_helper.dart';
import '../model/GetAreaModel.dart';
import '../model/GetAssetModel.dart';
import '../model/GetChargeAreaModel.dart';
import '../model/GetControlRoomModel.dart';
import '../model/GetCustomerLocationModel.dart';
import '../model/GetIncidentIndicationModel.dart';
import '../model/GetIncidentTypeModel.dart';
import '../model/GetLocationSourceModel.dart';
import '../model/GetModuleTypeModel.dart';
import '../model/GetPriorityTypeModel.dart';
import 'maintenance_alert_event.dart';
import 'maintenance_alert_state.dart';

class MaintenanceAlertBloc extends Bloc<MaintenanceAlertEvent, MaintenanceAlertState> {
  MaintenanceAlertBloc() : super(MaintenanceAlertInitialState()) {
    on<MaintenanceAlertLoadEvent>(_pageLoad);
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
  bool isLoader =  false;
  bool isBtnLoader =  false;
  bool isModuleLoader =  false;
  bool isChargeAreaLoader =  false;
  bool isAreaLoader =  false;
  bool isCustomerTypeLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';

  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController searchNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController infoSecurityNameController = TextEditingController();
  TextEditingController infoSecurityIdController = TextEditingController();
  TextEditingController infoSecurityMobileController = TextEditingController();
  TextEditingController infoCustomerNameController = TextEditingController();
  TextEditingController infoCustomerBpNumberController = TextEditingController();
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

  GetIncidentIndicationModel incidentIndicationModel = GetIncidentIndicationModel();
  GetIncidentIndicationData incidentIndicationValue = GetIncidentIndicationData();
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



  _pageLoad(MaintenanceAlertLoadEvent event, emit) async {
    emit(MaintenanceAlertInitialState());
    photo = File('');
    isLoader =  false;
    isBtnLoader =  false;
    isModuleLoader =  false;
    isChargeAreaLoader =  false;
    isAreaLoader =  false;
    isCustomerTypeLoader =  false;
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
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    await fetchOutageModuleApi(context: event.context);
    await fetchLocationSourceApi(context: event.context);
    await fetchCustomerLocationSourceApi(context: event.context);
    await fetchInformationSourceApi(context: event.context);
    await fetchIncidentIndicationApi(context: event.context);
    await fetchChargeAreaListApi(context: event.context);
    await fetchAssetLocationSourceApi(context: event.context);
    await fetchGasValueGisApi(context: event.context);
    _eventCompleted(emit);
  }

  fetchOutageModuleApi({required BuildContext context}) async {
    var res = await MaintenanceAlertHelper.getOutageModuleApi(context: context);
    if (res != null) {
      moduleTypeModel = res;
      if(moduleTypeModel.data != null){
        listOfModuleType = moduleTypeModel.data!;
      }
      return res;
    }
  }
  fetchIncidentTypeApi({required BuildContext context, required String moduleId}) async {
    var res = await MaintenanceAlertHelper.getIncidentTypeApi(context: context,moduleId: moduleId);
    if (res != null) {
      incidentTypeModel = res;
      if(incidentTypeModel.data != null){
        listOfIncidentType = incidentTypeModel.data!;
      }
      return res;
    }
  }

  fetchIncidentPriorityApi({required BuildContext context, required String moduleId}) async {
    var res = await MaintenanceAlertHelper.getIncidentPriorityApi(context: context,moduleId: moduleId);
    if (res != null) {
      priorityTypeModel = res;
      if(priorityTypeModel.data != null){
        listOfPriorityType = priorityTypeModel.data!;
      }
      return res;
    }
  }
  fetchLocationSourceApi({required BuildContext context,}) async {
    var res = await MaintenanceAlertHelper.getLocationSourceApi(context: context,);
    if(res != null){
      listOfLocationSource = res;
    }
    return res;
  }
  fetchCustomerLocationSourceApi({required BuildContext context,}) async {
    var res = await MaintenanceAlertHelper.getCustomerLocationSourceApi(context: context,);
    if(res != null){
      listOfCustomerType = res;
    }
    return res;
  }

  fetchInformationSourceApi({required BuildContext context,}) async {
    var res = await MaintenanceAlertHelper.getInformationSourceApi(context: context,);
    if (res != null) {
      informationSourceModel = res;
      if(informationSourceModel.data != null){
        listOfInformationSource = informationSourceModel.data!;
      }
      return res;
    }
  }

  fetchIncidentIndicationApi({required BuildContext context,}) async {
    var res = await MaintenanceAlertHelper.getIncidentIndicationApi(context: context,);
    if (res != null) {
      incidentIndicationModel = res;
      if(incidentIndicationModel.data != null){
        listOfIncidentIndication = incidentIndicationModel.data!;
      }
      return res;
    }
  }

  fetchChargeAreaListApi({required BuildContext context,}) async {
    var res = await MaintenanceHttpHelper.getChargeAreaListApi(context: context,);
    if(res != null){
      listOfChargeArea = res;
    }
    return res;
  }

  fetchAllAreaApi({required BuildContext context,required String gid}) async {
    var res = await MaintenanceHttpHelper.getAllAreaApi(context: context,gid: gid);
    if(res != null){
      listOfArea = res;
    }
    return res;
  }

  fetchAssetLocationSourceApi({required BuildContext context,}) async {
    var res = await MaintenanceAlertHelper.getAssetLocationSourceApi(context: context,);
    if (res != null) {
      assetModel = res;
      if(assetModel.data != null){
        listOfAssetData = assetModel.data!;
      }
      return res;
    }
  }

  fetchGasValueGisApi({required BuildContext context,}) async {
    var res = await ReportAlertHelper.getGasValueGisApi(context: context,);
    if (res != null) {
      gasValueGISModel = res;
      if(gasValueGISModel.data != null){
        listOfAssetTypeId = gasValueGISModel.data!;
        return res;
      }
    }
  }

  fetchCustomerDetailByLocationApi({required BuildContext context, required String locationSource, required String search}) async {
    listOfCustomerLocationData = [];
    var res = await MaintenanceAlertHelper.getCustomerDetailByLocationApi(
        context: context, locationSource: locationSource, search: search);
    if (res != null) {
      customerLocationModel = res;
      if(customerLocationModel.data != null){
        listOfCustomerLocationData = customerLocationModel.data!;
        if(customerTypeValue.key == "1"){
          listOfSearchNumber = listOfCustomerLocationData.map((e) => e.bpNumber!).toList();
        }else if(customerTypeValue.key == "2"){
          listOfSearchNumber = listOfCustomerLocationData.map((e) => e.mobileNumber!).toList();
        }else if(customerTypeValue.key == "3"){
          listOfSearchNumber = listOfCustomerLocationData.map((e) => e.serialNumber!).toList();
        }else{
          listOfSearchNumber = listOfCustomerLocationData.map((e) => e.bpNumber!).toList();
        }
      }
      return res;
    }
  }

  fetchControlRoomApi({required BuildContext context, required String areaId}) async {
    listOfCustomerLocationData = [];
    var res = await MaintenanceAlertHelper.getControlRoomApi(context: context, areaId: areaId,);
    if (res != null) {
      controlRoomModel = res;
      if(controlRoomModel.data != null){
        listOfControlRoom = controlRoomModel.data!;
      }
      return res;
    }
  }

  _selectModuleValue(SelectModuleValueEvent event, Emitter<MaintenanceAlertState> emit) async {
    incidentTypeModel = GetIncidentTypeModel();
    incidentTypeValue = GetIncidentTypeData();
    listOfIncidentType = [];
    priorityTypeModel = GetPriorityTypeModel();
    priorityTypeValue = GetPriorityTypeData();
    listOfPriorityType = [];
    moduleTypeValue = event.moduleTypeValue;
    if(event.moduleTypeValue.id != null){
      isModuleLoader = true;
      _eventCompleted(emit);
      await fetchIncidentTypeApi(context: event.context, moduleId: event.moduleTypeValue.id!);
      await fetchIncidentPriorityApi(context: event.context, moduleId: event.moduleTypeValue.id!);
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
  _selectIncidentIndicationValue(SelectIncidentIndicationValueEvent event, emit) {
    incidentIndicationValue = event.incidentIndicationValue;
    _eventCompleted(emit);
  }

  _selectChargeAreaValue(SelectChargeAreaValueEvent event, emit) async {
    areaValue = GetAreaModel();
    listOfArea = [];
    chargeAreaValue = event.chargeAreaValue;
    if(chargeAreaValue.gid != null){
      isChargeAreaLoader = true;
      _eventCompleted(emit);
      await fetchAllAreaApi(context: event.context, gid: event.chargeAreaValue.gid!);
      isChargeAreaLoader = false;
      _eventCompleted(emit);
    }
  }

  _selectAreaValue(SelectAreaValueEvent event, emit) async {
    controlRoomValue = GetControlRoomData();
    listOfControlRoom = [];
    areaValue = event.areaValue;
    if(areaValue.gid != null){
      isAreaLoader = true;
      _eventCompleted(emit);
      await fetchControlRoomApi(context: event.context, areaId: areaValue.gid ?? "");
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
    if(customerTypeValue.key != null){
      isCustomerTypeLoader = true;
      _eventCompleted(emit);

      await fetchCustomerDetailByLocationApi(
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
    if(customerTypeValue.key == "1"){
      searchNumberController.text = listOfCustomerLocationData.firstWhereOrNull((element) =>
      element.bpNumber == event.searchNumberValue)?.bpNumber ??"";
    }else if(customerTypeValue.key == "2"){
      searchNumberController.text = listOfCustomerLocationData.firstWhereOrNull((element) =>
      element.mobileNumber == event.searchNumberValue)?.mobileNumber ??"";
    }else if(customerTypeValue.key == "3"){
      searchNumberController.text = listOfCustomerLocationData.firstWhereOrNull((element) =>
      element.serialNumber == event.searchNumberValue)?.serialNumber ??"";
    }else{
      searchNumberController.text = listOfCustomerLocationData.firstWhereOrNull((element) =>
      element.bpNumber == event.searchNumberValue)?.bpNumber ??"";
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
      var validationCheck = await MaintenanceAlertHelper.validationSubmit(
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
          photo: photo
      );
      if(await validationCheck == true){
        isBtnLoader = false;
        _eventCompleted(emit);
        var res = await MaintenanceAlertHelper.addIncidentData(
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
          latitude: '',
          longitude: "",
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

  _eventCompleted(Emitter<MaintenanceAlertState> emit) {
    emit(FetchMaintenanceAlertDataState(
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
      incidentTypeModel : incidentTypeModel,
      incidentTypeValue : incidentTypeValue,
      listOfIncidentType : listOfIncidentType,
      priorityTypeModel : priorityTypeModel,
      priorityTypeValue : priorityTypeValue,
      listOfPriorityType : listOfPriorityType,
      locationSourceModel : locationSourceModel,
      locationSourceValue : locationSourceValue,
      listOfLocationSource : listOfLocationSource,
      informationSourceModel : informationSourceModel,
      informationSourceValue : informationSourceValue,
      listOfInformationSource : listOfInformationSource,
      incidentIndicationModel : incidentIndicationModel,
      incidentIndicationValue : incidentIndicationValue,
      listOfIncidentIndication : listOfIncidentIndication,
      listOfSearchNumber : listOfSearchNumber,
      chargeAreaValue : chargeAreaValue,
      listOfChargeArea : listOfChargeArea,
      areaValue  : areaValue,
      listOfArea : listOfArea,
      customerTypeValue: customerTypeValue,
      listOfCustomerType: listOfCustomerType,
      assetModel : assetModel,
      assetDataValue : assetDataValue,
      listOfAssetData : listOfAssetData,
      assetTypeIdValue : assetTypeIdValue,
      listOfAssetTypeId : listOfAssetTypeId,
      controlRoomModel: controlRoomModel,
      controlRoomValue: controlRoomValue,
      listOfControlRoom: listOfControlRoom,
      addressController : addressController,
      landmarkController : landmarkController,
      searchNumberController : searchNumberController,
      locationController : locationController,
      infoSecurityNameController : infoSecurityNameController,
      infoSecurityIdController : infoSecurityIdController,
      infoSecurityMobileController : infoSecurityMobileController,
      infoCustomerNameController : infoCustomerNameController,
      infoCustomerBpNumberController : infoCustomerBpNumberController,
      infoCustomerMobileController : infoCustomerMobileController,
      infoOtherNameController :infoOtherNameController,
      descriptionController: descriptionController,
      remarksController: remarksController,
    ));
  }
}
