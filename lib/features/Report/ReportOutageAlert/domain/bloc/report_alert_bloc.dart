import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/Utils.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/GisConfig.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/IndustrialModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ValveGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/getNearestPoint.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/presentation/widget/alert_dialog_widget.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/presentation/widget/report_pop_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'report_alert_event.dart';
import 'report_alert_state.dart';

class ReportAlertBloc extends Bloc<ReportAlertEvent, ReportAlertState> {
  ReportAlertBloc() : super(ReportAlertInitialState()) {
    on<ReportAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectCurrentMarkerButtonEvent>(_selectCurrentMarkerButton);
    on<SelectGoogleMapButtonEvent>(_selectGoogleMapButton);
    on<SelectGoogleRouteDirEvent>(_selectGoogleRouteDirEvent);
    on<SelectFilterButtonEvent>(_selectFilterButton);

    on<SelectCheckBoxTFGisEvent>(_selectCheckBoxTFGis);
    on<SelectTFGisEvent>(_selectTFGisValue);

    on<SelectCheckBoxValveGisEvent>(_selectCheckBoxValveGis);
    on<SelectValveGISValueEvent>(_selectValveGISValue);

    on<SelectCheckBoxRegulatorGisEvent>(_selectCheckBoxRegulatorGis);
    on<SelectRegulatorGISValueEvent>(_selectRegulatorGISValue);

    on<SelectCheckCommercialEvent>(_selectCheckCommercial);
    on<SelectCommercialValueEvent>(_selectCommercialValue);

    on<SelectCheckDomesticEvent>(_selectCheckDomestic);
    on<SelectDomesticValueEvent>(_selectDomesticValue);

    on<SelectCheckIndustrialEvent>(_selectCheckIndustrial);
    on<SelectIndustrialValueEvent>(_selectIndustrial);
    

    on<OnCameraIdleEvent>(_onCameraIdleEvent);
    on<ResetFilterEvent>(_onResetFilterEvent);
  }

  bool isLoader = false;
  bool isMapDir = false;
  bool isPipelineLoader = false;
  bool checkBoxTf = false;
  bool isGasTfLoader = false;
  bool checkBoxValve = false;
  bool isGasValveLoader = false;
  bool checkBoxRegulator = false;
  bool isGasRegulatorLoader = false;
  bool checkCommercial = false;
  bool isCommercial = false;
  bool checkDomestic = false;
  bool isDomestic = false;
  bool checkIndustrial = false;
  bool isIndustrial = false;

  String role = '';
  String baseUrl = '';
  String nameofLocation = '';
  String googleMapsUrl = "";

  final TextEditingController tfGisController = TextEditingController();
  final TextEditingController gasValveGISController = TextEditingController();
  final TextEditingController gasRegulatorGISController =
      TextEditingController();
  final TextEditingController commercialController = TextEditingController();
  final TextEditingController domesticController = TextEditingController();
  final TextEditingController industrialController = TextEditingController();



  GetGasValueGISModel fittingGISModel = GetGasValueGISModel();
  List<GetGasValueGISData> listOfFittingGIS = [];

  TFGISModel tfGisModel = TFGISModel();
  TFGISData detailsTf = TFGISData();
  List<TFGISData> listOfTfGis = [];
  List<TFGISData> listOfFilterTfGis = [];
  List<String> listOfTfGisId = [];

  ValveGISModel gasValueGISModel = ValveGISModel();
  ValveGISData detailsValve = ValveGISData();
  List<ValveGISData> listOfGasValueGIS = [];
  List<ValveGISData> listOfFilterGasValueGIS = [];
  List<String> listOfGasValveGISId = [];

  RegulatorGISModel gasRegulatorGISModel = RegulatorGISModel();
  RegulatorGISData detailsRegulator = RegulatorGISData();
  List<RegulatorGISData> listOfGasRegulatorGIS = [];
  List<RegulatorGISData> listOfFilterGasRegulatorGIS = [];
  List<String> listOfGasRegulatorGISId = [];

  CommercialModel commercialModel = CommercialModel();
  CommercialData detailsCommercial = CommercialData();
  List<CommercialData> listOfCommercial = [];
  List<CommercialData> listOfFilterCommercial = [];
  List<String> listOfCommercialId = [];

  DomesticModel domesticModel = DomesticModel();
  DomesticData detailsDomestic = DomesticData();
  List<DomesticData> listOfDomestic = [];
  List<DomesticData> listOfFilterDomestic = [];
  List<String> listOfDomesticId = [];

  IndustrialModel industrialModel = IndustrialModel();
  IndustrialData detailsIndustrial = IndustrialData();
  List<IndustrialData> listOfIndustrial = [];
  List<IndustrialData> listOfFilterIndustrial = [];
  List<String> listOfIndustrialId = [];

  List<String> listOfDiaColor = [];

  GetPipelineNetworkModel pipelineNetworkModel = GetPipelineNetworkModel();
  PipelineNetworkData pipelineNetworkData = PipelineNetworkData();
  List<PipelineNetworkData> listOfPipelineNetwork = [];


  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];

  LatLng currentPosition = LatLng(0, 0);
  LatLng latLngOnTap = LatLng(0, 0);
  List<LatLng> points = [];
  List<LatLng> allLatLongPoint = [];

  Set<Marker> tempMarker = {};
  Set<Marker> filterMarkerList = {};
  Set<Marker> finalMarker = {};
  Set<Marker> tfMarker = {};
  Set<Marker> valveMarker = {};
  Set<Marker> regularMarker = {};
  Set<Marker> commercialMarker = {};
  Set<Marker> domesticMarker = {};
  Set<Marker> industrialMarker = {};
  Set<Marker> markersPointList = {};

  Set<Polyline> polylinePointList = {};
  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> filterPolyline = {};
  Set<Polyline> finalPolyline = {};

  MapType currentMapType = MapType.normal;

  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition position = CameraPosition(
    target: LatLng(0, 0),
    zoom: AppString.zoom,
  );
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  _pageLoad(ReportAlertLoadEvent event, emit) async {
    emit(ReportAlertPageLoadState());
    isLoader = false;
    isMapDir = false;
    _initializeAllModels();
    ReportAlertHelper.clearCache();
    await _selectGISValue(
      assetId: "",
      assetTypeId: "",
      dataList: [],
      controller: TextEditingController(),
      context: event.context,
      assetPath: "",
      filteredList: [],
      data: ""
    );

      var res = await ReportAlertHelper.getDiaColorApi(context: event.context);
      if (res != null) {
        listOfDiaColor = res;
      }

    await _currentPointMarker();
    await _fetchGasPipelineGisApi(context: event.context, emit: emit);
    _eventCompleted(emit);
  }

  Future<void> _initializeAllModels() async {
    isPipelineLoader = false;
    points = [];
    googleMapsUrl = "";
    await _clearTextField();
    detailsTf = TFGISData();
    gasValueGISModel = ValveGISModel();
    detailsValve = ValveGISData();
    detailsRegulator = RegulatorGISData();

    detailsCommercial = CommercialData();
    listOfGasValueGIS = [];
    listOfFilterGasValueGIS = [];
    listOfGasValveGISId = [];
    fittingGISModel = GetGasValueGISModel();
    listOfFittingGIS = [];
    tfGisModel = TFGISModel();
    listOfTfGis = [];
    listOfFilterTfGis = [];
    listOfTfGisId = [];
    gasRegulatorGISModel = RegulatorGISModel();
    listOfGasRegulatorGIS = [];
    listOfFilterGasRegulatorGIS = [];
    listOfGasRegulatorGISId = [];




     domesticModel = DomesticModel();
     detailsDomestic = DomesticData();
     listOfDomestic = [];
    listOfFilterDomestic = [];
    listOfDomesticId = [];

    industrialModel = IndustrialModel();
     detailsIndustrial = IndustrialData();
     listOfIndustrial = [];
     listOfFilterIndustrial = [];
    listOfIndustrialId = [];





    commercialModel = CommercialModel();
    listOfCommercial = [];
    listOfFilterCommercial = [];
    listOfCommercialId = [];
    listOfDiaColor = [];

    pipelineNetworkModel = GetPipelineNetworkModel();
    pipelineNetworkData = PipelineNetworkData();
    listOfPipelineNetwork = [];


    pipelineData = PipelineData();
    listOfPipeline = [];
    currentPosition = LatLng(0, 0);
    latLngOnTap = LatLng(0, 0);

    tempMarker = {};
    finalMarker = {};
    filterMarkerList = {};
    tfMarker = {};
    valveMarker = {};
    regularMarker = {};
   commercialMarker = {};
    domesticMarker = {};
    industrialMarker = {};
    markersPointList = {};

    filterPolyline = {};
    polylinePointList = {};
    pipePolylinePointList = {};


    allLatLongPoint = [];
    googleMapController = Completer();

    currentMapType = MapType.normal;
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
  }

  _fetchGasPipelineGisApi({required BuildContext context, emit}) async {
    if (await HiveDataBase.pipelineDataBox!.values.isEmpty) {
      var res = await ReportAlertHelper.getPipelineApi(
        context: context,
        latitude: AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
        longitude: AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
      );
      if(res != null && res.data != null){
        listOfPipeline = res.data!;
      }
    } else {
      listOfPipeline = await HiveDataBase.pipelineDataBox!.values.toList();
    }
    if (listOfPipeline.isNotEmpty) {
      finalPolyline.clear();
      finalMarker.clear();
      _eventCompleted(emit);
      for (int i = 0; i < listOfPipeline.length; i++) {
        pipelineData = listOfPipeline[i];
        if (pipelineData.geomencode != null && pipelineData.geomencode!.isNotEmpty) {
          try {
            points = await DecodePolyline.decodePolyline(pipelineData.geomencode!);
            final color = ReportAlertHelper.getPolylineColor(
                value : int.tryParse(pipelineData.nominaldia ?? '0') ?? 0,
                color: listOfDiaColor);
            Set<Polyline> polyline = ReportAlertHelper.polylinePoint(
              i: i,
              color: color,
              position: points,
              context: context,
            );
            finalPolyline.addAll(polyline);
          } catch (e) {
            print("Error decoding polyline at index $i: $e");
          }
        }
      }
      await  _filterVisiblePolyline();
      await gotoInitialPosition(points[0]);
      _eventCompleted(emit);
    }
  }



  _onResetFilterEvent(ResetFilterEvent event, emit) async {
    tempMarker = {};
    await gotoInitialPosition(points[0]);
    _clearTextField();
    _clearMarkerPolyline();
    Navigator.pop(event.context, true);
    _eventCompleted(emit);
  }

  _onCameraIdleEvent(OnCameraIdleEvent event, emit) async {
    await ReportAlertHelper.clearCache();
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  gotoInitialPosition(LatLng location) async {
    position = CameraPosition(target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<void> _filterVisiblePolyline() async {
    final controller = await googleMapController.future;
    final bounds = await controller.getVisibleRegion();
    pipePolylinePointList =
        finalPolyline.where((polyline) {
          return polyline.points.any(
            (point) => DecodePolyline.isPointInBounds(point, bounds),
          );
        }).toSet();
    markersPointList =
        finalMarker.where((marker) {
          return [
            marker.position,
          ].any((points) => DecodePolyline.isPointInBounds(points, bounds));
        }).toSet();

    _updateMarkerPolyline();
  }

  _updateMarkerPolyline() {
    polylinePointList = {...pipePolylinePointList, ...filterPolyline};
    markersPointList = {...markersPointList, ...filterMarkerList};
    print("pipePolylinePointList-->${pipePolylinePointList.length}");
    print("filterPolyline-->${filterPolyline.length}");
    print("markersPointList-->${markersPointList.length}");
    print("filterMarkerList-->${filterMarkerList.length}");
  }

  _fetchTFGisApi({required BuildContext context, emit}) async {
    if (checkBoxTf == true) {
      try {
        if (await HiveDataBase.tfGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getTFGisApi(context: context);
          if (res != null) {
            tfGisModel = res;
            if (tfGisModel.data != null) {
              listOfTfGis = tfGisModel.data!;
              await HiveDataBase.tfGISBox!.addAll(listOfTfGis);
            }
          }
        } else {
          listOfTfGis = await HiveDataBase.tfGISBox!.values.toList();
        }
        if (listOfTfGis.isNotEmpty) {
          listOfTfGisId = listOfTfGis.map((e) => e.id ?? "").toList();
          final customIcon = await ReportAlertHelper.markerAsset(AssetPath.tf);
          for (int i = 0; i < listOfTfGis.length; i++) {
            detailsTf = listOfTfGis[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsTf.latitude!),
                double.parse(detailsTf.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                assetId: tfGisModel.assetId ?? "",
                assetsTypeId: detailsTf.id ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsTf,
              );
              tfMarker.addAll(marker);
              finalMarker.addAll(tfMarker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during TFGis API fetching: $e");
      }
    }
    _eventCompleted(emit);
  }


  _fetchGasValueGisApi({required BuildContext context, emit}) async {
    if (checkBoxValve == true) {
      try {
        if (await HiveDataBase.valveGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getGasValueGisApi(context: context);
          if (res != null) {
            gasValueGISModel = res;
            if (gasValueGISModel.data != null) {
              listOfGasValueGIS = gasValueGISModel.data!;
            }
          }
        } else {
          listOfGasValueGIS = await HiveDataBase.valveGISBox!.values.toList();
        }
        if (listOfGasValueGIS.isNotEmpty) {
          listOfGasValveGISId = listOfGasValueGIS.map((e) => e.valveId ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.valve,
          );
          for (int i = 0; i < listOfGasValueGIS.length; i++) {
            detailsValve = listOfGasValueGIS[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsValve.latitude!),
                double.parse(detailsValve.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                assetId: gasValueGISModel.assetId ?? "",
                assetsTypeId: detailsValve.valveId ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsValve,
              );
              valveMarker.addAll(marker);
              finalMarker.addAll(valveMarker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Valve GIS API fetching: $e");
      }
    }

    _eventCompleted(emit);
  }

  _fetchGasRegulatorGisApi({required BuildContext context, emit}) async {
    if (checkBoxRegulator == true) {
      try {
        if (await HiveDataBase.regulatorGISBox!.isEmpty) {
          var res = await ReportAlertHelper.getRegulatorGisApi(context: context);
          if (res != null) {
            gasRegulatorGISModel = res;
            if (gasRegulatorGISModel.data != null) {
              listOfGasRegulatorGIS = gasRegulatorGISModel.data!;
            }
          }
        } else {
          listOfGasRegulatorGIS = await HiveDataBase.regulatorGISBox!.values.toList();
        }
        if (listOfGasRegulatorGIS.isNotEmpty) {
          listOfGasRegulatorGISId =
              listOfGasRegulatorGIS.map((e) => e.id ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.regulator,
          );
          for (int i = 0; i < listOfGasRegulatorGIS.length; i++) {
            detailsRegulator = listOfGasRegulatorGIS[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsRegulator.latitude!),
                double.parse(detailsRegulator.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                assetId: gasRegulatorGISModel.assetId ?? "",
                assetsTypeId: detailsRegulator.id ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsRegulator,
              );
              regularMarker.addAll(marker);
              finalMarker.addAll(regularMarker);
            } catch (e) {
              print("Error decoding fetchGasRegulatorGisApi $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error _fetchGasRegulatorGisApi: $e");
      }
    }

    _eventCompleted(emit);
  }


  _fetchCommercialApi({required BuildContext context, emit}) async {
    if (checkCommercial == true) {
      try {
        if (await HiveDataBase.commercialDataBox!.isEmpty) {
          var res = await ReportAlertHelper.getCommercialApi(context: context);
          if (res != null) {
            commercialModel = res;
            if (commercialModel.data != null) {
              listOfCommercial = commercialModel.data!;
            }
          }
        } else {
          listOfCommercial = await HiveDataBase.commercialDataBox!.values.toList();
        }
        if (listOfCommercial.isNotEmpty) {
          listOfCommercialId =
              listOfCommercial.map((e) => e.id ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.consumer,
          );
          for (int i = 0; i < listOfCommercial.length; i++) {
            detailsCommercial = listOfCommercial[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsCommercial.latitude!),
                double.parse(detailsCommercial.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
              //  assetId: commercialModel.assetId ?? "",
                assetId: "",
                assetsTypeId: detailsCommercial.id ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsCommercial,
              );
              commercialMarker.addAll(marker);
              finalMarker.addAll(commercialMarker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }
    _eventCompleted(emit);
  }

  _fetchDomesticApi({required BuildContext context, emit}) async {
    if (checkDomestic == true) {
      try {
        if (await HiveDataBase.domesticDataBox!.isEmpty) {
          var res = await ReportAlertHelper.getDomesticApi(context: context);
          if (res != null) {
            domesticModel = res;
            if (domesticModel.data != null) {
              listOfDomestic = domesticModel.data!;

            }
          }
        } else {
          listOfDomestic = await HiveDataBase.domesticDataBox!.values.toList();
        }
        if (listOfDomestic.isNotEmpty) {
          listOfDomesticId =
              listOfDomestic.map((e) => e.id ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.consumer,
          );
          for (int i = 0; i < listOfDomestic.length; i++) {
            detailsDomestic = listOfDomestic[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsDomestic.latitude!),
                double.parse(detailsDomestic.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                //  assetId: commercialModel.assetId ?? "",
                assetId: "",
                assetsTypeId: detailsDomestic.id ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsDomestic,
              );
              domesticMarker.addAll(marker);
              finalMarker.addAll(domesticMarker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }
    _eventCompleted(emit);
  }

  _fetchIndustrialApi({required BuildContext context, emit}) async {
    if (checkIndustrial == true) {
      try {
        if (await HiveDataBase.industrialDataBox!.isEmpty) {
          var res = await ReportAlertHelper.getIndustrialApi(context: context);
          if (res != null) {
            industrialModel = res;
            if (industrialModel.data != null) {
              listOfIndustrial = industrialModel.data!;

            }
          }
        } else {
          listOfIndustrial = await HiveDataBase.industrialDataBox!.values.toList();
        }
        if (listOfIndustrial.isNotEmpty) {
          listOfIndustrialId =
              listOfIndustrial.map((e) => e.id ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            AssetPath.consumer,
          );
          for (int i = 0; i < listOfIndustrial.length; i++) {
            detailsIndustrial = listOfIndustrial[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsIndustrial.latitude!),
                double.parse(detailsIndustrial.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                //  assetId: commercialModel.assetId ?? "",
                assetId: "",
                assetsTypeId: detailsIndustrial.id ?? "",
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsIndustrial,
              );
              industrialMarker.addAll(marker);
              finalMarker.addAll(industrialMarker);
            } catch (e) {
              print("Error decoding polyline at index $i: $e");
            }
          }
          _filterVisiblePolyline();
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }
    _eventCompleted(emit);
  }

  _fetchPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    await _clearMarkerPolyline();
    try {
      var res = await ReportAlertHelper.getPipelineNetworkApi(
        context: context,
        latitude: latitude,
        longitude: longitude,
      );
      if (res != null) {
        pipelineNetworkModel = res;
        if (pipelineNetworkModel.data?.isNotEmpty ?? false) {
          listOfPipelineNetwork = pipelineNetworkModel.data!;
          final gisConfig = await _getActiveGisConfig();
          for (int i = 0; i < listOfPipelineNetwork.length; i++) {
            final data = listOfPipelineNetwork[i];
            if (data.geomencode != null && data.geomencode!.isNotEmpty) {
              try {
                List<LatLng> filterLatLngGis =
                    await DecodePolyline.decodePolyline(data.geomencode!);
                final color = ReportAlertHelper.getPolylineColor(
                    value : int.tryParse(data.nominaldia ?? '0') ?? 0,
                    color: listOfDiaColor);
                Set<Polyline> polyline = ReportAlertHelper.polylinePoint(
                  i: i,
                  color: color,
                  position: filterLatLngGis,
                  context: context,
                );
                gisConfig?.polylineList?.addAll(polyline);
                filterPolyline.addAll(polyline);
              } catch (e) {
                print("Error decoding polyline at index $i: $e");
              }
            }
          }
          _updateMarkerPolyline();
        } else {
          Utils.errorSnackBar(
            msg: "No pipeline data available.",
            context: context,
          );
        }
      } else {
        Utils.errorSnackBar(
          msg: "Failed to fetch pipeline network data.",
          context: context,
        );
      }
    } catch (e) {
      Utils.errorSnackBar(
        msg: "An error occurred: ${e.toString()}",
        context: context,
      );
    }
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _selectCurrentMarkerButton(SelectCurrentMarkerButtonEvent event, emit) async {
    await _currentPointMarker();
    _eventCompleted(emit);
  }

  _currentPointMarker() async {
    Position? currentPoint = await CurrentLocation.getCurrentLocation();
    if (currentPoint != null) {
      currentPosition = LatLng(currentPoint.latitude, currentPoint.longitude);
      position = CameraPosition(target: currentPosition, zoom: 14);
       gotoInitialPosition(currentPosition);
    }
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTf = event.checkBoxTf;
    if (checkBoxTf == true) {
      isGasTfLoader = true;
      _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context, emit: emit);
    }else{
      finalMarker.removeWhere((marker) => tfMarker.contains(marker));
      tfMarker.clear();            
      _eventCompleted(emit);
    }
    isGasTfLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxValve = event.checkBoxValve;
    if (checkBoxValve == true) {
      isGasValveLoader = true;
      _eventCompleted(emit);
      await _fetchGasValueGisApi(context: event.context, emit: emit);
    }else{
      finalMarker.removeWhere((marker) => valveMarker.contains(marker));
      valveMarker.clear();            
      _eventCompleted(emit);
    }
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxRegulatorGis(
    SelectCheckBoxRegulatorGisEvent event,
    emit,
  ) async {
    await _clearPopTextField();
    checkBoxRegulator = event.checkBoxRegulator;
    if (checkBoxRegulator == true) {
      isGasRegulatorLoader = true;
      _eventCompleted(emit);
      await _fetchGasRegulatorGisApi(context: event.context, emit: emit);
    }else{
      finalMarker.removeWhere((marker) => regularMarker.contains(marker));
      regularMarker.clear();            
      _eventCompleted(emit);
    }
    isGasRegulatorLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckCommercial(SelectCheckCommercialEvent event, emit) async {
    await _clearPopTextField();
    checkCommercial = event.checkCommercial;
    if (checkCommercial == true) {
      isCommercial = true;
      _eventCompleted(emit);
      await _fetchCommercialApi(context: event.context,emit: emit);
    }
    isCommercial = false;
    _eventCompleted(emit);
  }

  _selectCheckDomestic(SelectCheckDomesticEvent event, emit) async {
    await _clearPopTextField();
    checkDomestic = event.checkDomestic;
    if (checkDomestic == true) {
      isDomestic = true;
      _eventCompleted(emit);
      await _fetchDomesticApi(context: event.context,emit: emit);
    }
    isDomestic = false;
    _eventCompleted(emit);
  }

  _selectCheckIndustrial(SelectCheckIndustrialEvent event, emit) async {
    await _clearPopTextField();
    checkIndustrial = event.checkIndustrial;
    if (checkIndustrial == true) {
      isIndustrial = true;
      _eventCompleted(emit);
      await _fetchIndustrialApi(context: event.context, emit: emit);
    }
    isIndustrial = false;
    _eventCompleted(emit);
  }



  Future<GisConfig?> _getActiveGisConfig() async {
    if (tfGisController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsTf
      );
    } else if (gasValveGISController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsValve
      );
    } else if (gasRegulatorGISController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsRegulator
      );
    } else if (commercialController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsCommercial
      );
    } else if (domesticController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsDomestic
      );
    } else if (industrialController.text.isNotEmpty) {
      return GisConfig(

        markerList: filterMarkerList,
        polylineList: filterPolyline,
        detailsData: detailsIndustrial
      );
    }
    if (filterMarkerList.isNotEmpty) {
      GoogleMapController controller = await googleMapController.future;
      currentPosition = LatLng(
        filterMarkerList.first.position.latitude,
        filterMarkerList.first.position.longitude,
      );
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 18),
        ),
      );
    }
    return null;
  }

  _selectGISValue({
    required String assetId,
    required String assetTypeId,
    required List dataList,
    required TextEditingController controller,
    required BuildContext context,
    required String assetPath,
    required List filteredList,
    required dynamic data,
  }) async {
    filteredList.clear();
    assetId == '';
    assetTypeId == '';
    _clearMarkerPolyline();
    controller.text = assetTypeId;
    if (controller.text.isNotEmpty) {
      filteredList.addAll(
        dataList.where((data) {
          if (gasValveGISController.text.isNotEmpty) {
            return data.valveId.toString() == assetTypeId;
          } else {
            return data.toString() == assetTypeId;
          }
        }).toList(),
      );
      if (filteredList.isNotEmpty) {
        final iconBytes = await ReportAlertHelper.markerAsset(assetPath);
        LatLng location = LatLng(
          double.parse(filteredList[0].latitude!),
          double.parse(filteredList[0].longitude!),
        );
        Set<Marker> markers = await ReportAlertHelper.markerPoint(
          position: location,
          context: context,
          icon: iconBytes,
          assetId: assetId,
          assetsTypeId: assetTypeId,
          data: data

        );
       await _fetchPipelineNetworkApi(
          context: context,
          latitude: location.latitude.toString(),
          longitude: location.longitude.toString(),
        );
        tempMarker.addAll(markers);
        markersPointList = tempMarker;
        if (tempMarker.isNotEmpty) {
          GoogleMapController controller = await googleMapController.future;
          currentPosition = LatLng(
            tempMarker.first.position.latitude,
            tempMarker.first.position.longitude,
          );
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: currentPosition, zoom: 17 ),
            ),
          );
        }
      }
    } else {
      AppConfig.instanceInit()?.setAssets(assets: '');
      AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: '');
    }
  }

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: tfGisModel.assetId!,
      assetTypeId: event.tfGisId,
      dataList: listOfTfGis,
      controller: tfGisController,
      context: event.context,
      assetPath: AssetPath.tf,
      filteredList: listOfFilterTfGis,
      data: detailsTf
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasValueGISModel.assetId ?? "",
      assetTypeId: event.gasValveGISId,
      dataList: listOfGasValueGIS,
      controller: gasValveGISController,
      context: event.context,
      assetPath: AssetPath.valve,
      filteredList: listOfFilterGasValueGIS,
      data: detailsValve
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectRegulatorGISValue(SelectRegulatorGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: gasRegulatorGISModel.assetId ?? "",
      assetTypeId: event.gasRegulatorGISId,
      dataList: listOfGasRegulatorGIS,
      controller: gasRegulatorGISController,
      context: event.context,
      assetPath: AssetPath.regulator,
      filteredList: listOfFilterGasRegulatorGIS,
      data: detailsRegulator
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCommercialValue(SelectCommercialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: "",
      assetTypeId: event.commercialId,
      dataList: listOfCommercial,
      controller: commercialController,
      context: event.context,
      assetPath: AssetPath.tee,
      filteredList: listOfFilterCommercial,
      data: detailsCommercial
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }
  _selectDomesticValue(SelectDomesticValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: "",
      assetTypeId: event.domesticId,
      dataList: listOfDomestic,
      controller: domesticController,
      context: event.context,
      assetPath: AssetPath.elbow,
      filteredList: listOfFilterDomestic,
      data: detailsDomestic
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectIndustrial(SelectIndustrialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      assetId: "",
      assetTypeId: event.industrialId,
      dataList: listOfIndustrial,
      controller: industrialController,
      context: event.context,
      assetPath: AssetPath.coupler,
      filteredList: listOfFilterIndustrial,
      data: detailsIndustrial
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }



  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    final currentPoint = await CurrentLocation.getCurrentLocation();
    latLngOnTap = event.latLngOnTap;
    isMapDir = true;
    googleMapsUrl =
    "https://www.google.com/maps/dir/?api=1&origin=${currentPoint?.latitude},${currentPoint?.longitude}&destination=${latLngOnTap.latitude},${latLngOnTap.longitude}&travelmode=driving&dir_action=navigate";
    print("googleMapsUrl --> $googleMapsUrl");

    final placemarks = await placemarkFromCoordinates(
      latLngOnTap.latitude,
      latLngOnTap.longitude,
    );
    nameofLocation = placemarks.isNotEmpty
        ? '${placemarks[0].administrativeArea}, ${placemarks[0].locality}, ${placemarks[0].country}'
        : 'Unknown Location';

    print("nameofLocation --> $nameofLocation");
    Set<Marker> tempMarker = Set.from(markersPointList);
    for (var polyData in polylinePointList) {
      for (int i = 0; i < polyData.points.length - 1; i++) {
        final start = polyData.points[i];
        final end = polyData.points[i + 1];
        if (NearestPolylinePoint.isPointNearLine(
          event.latLngOnTap,
          start,
          end,
        )) {
          tempMarker.add(
            Marker(
              markerId: MarkerId('Pipeline'),
              position: event.latLngOnTap,
              infoWindow: InfoWindow(
                  title: 'Create Report Incident',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow,
              ),
              onTap: () async {
                if(polylinePointList.isNotEmpty){
                  AppConfig.instanceInit()?.setAssets(assets: "");
                  AppConfig.instanceInit()?.setAssetsTypeId(assetsTypeId: "");
                  AppConfig.instanceInit()?.setMarkerPoint(
                    newPointMarkerLat: event.latLngOnTap.latitude.toString(),
                    newPointMarkerLong: event.latLngOnTap.longitude.toString(),
                  );
                }else if(markersPointList.isNotEmpty){
                  AppConfig.instanceInit()?.setMarkerPoint(
                    newPointMarkerLat: event.latLngOnTap.latitude.toString(),
                    newPointMarkerLong: event.latLngOnTap.longitude.toString(),
                  );
                }
                showDialog(
                  context: event.context,
                  builder: (context) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: AlertDialogTwoBtnWidget(mContext: context,pipelineData: pipelineData,),
                  ),
                );
              },
            ),
          );
          break;
        }
      }
    }
    markersPointList = tempMarker;
    _eventCompleted(emit);
  }

  _selectGoogleRouteDirEvent(SelectGoogleRouteDirEvent event, emit) async {
    if (isMapDir == true) {
      isMapDir = true;
      final Uri uri = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(uri)) {
        print("uri-->${uri}");
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    }
    _eventCompleted(emit);
  }

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    await showDialog(
      context: event.context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<ReportAlertBloc>(context),
          child: ReportPopWidget(mContext: event.context),
        );
      },
    );
    _eventCompleted(emit);
  }

  _clearTextField() async {
    checkBoxTf = false;
    isGasTfLoader = false;
    checkBoxValve = false;
    isGasValveLoader = false;
    checkBoxRegulator = false;
    isGasRegulatorLoader = false;
    checkCommercial = false;
    isCommercial = false;
    checkDomestic = false;
    isDomestic = false;
    checkIndustrial = false;
    isIndustrial = false;

    tfGisController.text = "";
    gasValveGISController.text = "";
    gasRegulatorGISController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";

  }

  _clearPopTextField() {
    isGasTfLoader = false;
    isGasValveLoader = false;
    isGasRegulatorLoader = false;
    isCommercial = false;
    isDomestic = false;
    isIndustrial = false;
    tfGisController.text = "";
    gasValveGISController.text = "";
    gasRegulatorGISController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";

  }

  _clearMarkerPolyline() {
    polylinePointList = {};
    markersPointList = {};
    filterPolyline = {};
    filterMarkerList = {};
    polylinePointList = {...pipePolylinePointList};
    markersPointList = {...markersPointList};
  }

  _eventCompleted(Emitter<ReportAlertState> emit) {
    emit(
      FetchReportAlertDataState(
        isLoader: isLoader,
        isMapDir: isMapDir,
        isPipelineLoader: isPipelineLoader,
        checkBoxTf: checkBoxTf,
        isGasTfLoader: isGasTfLoader,
        checkBoxValve: checkBoxValve,
        isGasValveLoader: isGasValveLoader,
        checkBoxRegulator: checkBoxRegulator,
        isGasRegulatorLoader: isGasRegulatorLoader,

        checkCommercial: checkCommercial,
        isCommercial: isCommercial,
        checkDomestic: checkDomestic,
        isDomestic: isDomestic,
        checkIndustrial: checkIndustrial,
        isIndustrial: isIndustrial,

        baseUrl: baseUrl,
        nameofLocation: nameofLocation,
        role: role,
        position: position,
        googleMapController: googleMapController,
        currentMapType: currentMapType,
        markersPointList: Set.of(markersPointList),
        currentPosition: currentPosition,
        polylinePointList: Set.of(polylinePointList),
        tfGisController: tfGisController,
        gasValveGISController: gasValveGISController,
        gasRegulatorGISController: gasRegulatorGISController,
        commercialController: commercialController,
        domesticController: domesticController,
        industrialController: industrialController,
        listOfTfGisId: listOfTfGisId,
        listOfGasValveGISId: listOfGasValveGISId,
        listOfGasRegulatorGISId: listOfGasRegulatorGISId,
        listOfCommercialId: listOfCommercialId,
        listOfDomesticId: listOfDomesticId,
        listOfIndustrialId: listOfIndustrialId,

      ),
    );
  }
}
