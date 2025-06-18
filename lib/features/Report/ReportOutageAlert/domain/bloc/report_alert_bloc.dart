import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool isCommercialLoader = false;
  bool checkDomestic = false;
  bool isDomesticLoader = false;
  bool checkIndustrial = false;
  bool isIndustrialLoader = false;

  String role = '';
  String baseUrl = '';
  String nameofLocation = '';
  String googleMapsUrl = "";

  final TextEditingController tfGisController = TextEditingController();
  final TextEditingController valveController = TextEditingController();
  final TextEditingController regulatorController = TextEditingController();
  final TextEditingController commercialController = TextEditingController();
  final TextEditingController domesticController = TextEditingController();
  final TextEditingController industrialController = TextEditingController();

  GetGasValueGISModel fittingGISModel = GetGasValueGISModel();
  List<GetGasValueGISData> listOfFittingGIS = [];


  TFGISData detailsTF = TFGISData();
  List<TFGISData> listOfTF = [];
  List<TFGISData> listOfFilterTF = [];
  List<String> listOfTFId = [];


  ValveGISData detailsValve = ValveGISData();
  List<ValveGISData> listOfValue = [];
  List<ValveGISData> listOfFilterValue = [];
  List<String> listOfValveId = [];


  RegulatorGISData detailsRegulator = RegulatorGISData();
  List<RegulatorGISData> listOfRegulator = [];
  List<RegulatorGISData> listOfFilterRegulator = [];
  List<String> listOfRegulatorId = [];


  CommercialData detailsCommercial = CommercialData();
  List<CommercialData> listOfCommercial = [];
  List<CommercialData> listOfFilterCommercial = [];
  List<String> listOfCommercialId = [];


  DomesticData detailsDomestic = DomesticData();
  List<DomesticData> listOfDomestic = [];
  List<DomesticData> listOfFilterDomestic = [];
  List<String> listOfDomesticId = [];


  IndustrialData detailsIndustrial = IndustrialData();
  List<IndustrialData> listOfIndustrial = [];
  List<IndustrialData> listOfFilterIndustrial = [];
  List<String> listOfIndustrialId = [];

  List<String> listOfDiaColor = [];

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




  _pageLoad(ReportAlertLoadEvent event, emit) async {
    emit(ReportAlertPageLoadState());
    isLoader = false;
    isMapDir = false;
    _initializeAllModels();
    ReportAlertHelper.clearCache();
    var icons = await ReportAlertHelper.markerAsset(path: "");
    await _selectGISValue(
      dataList: [],
      controller: TextEditingController(),
      context: event.context,
      iconBytes: icons,
      filteredList: [],
      data: "",
      emit: emit
    );

    var res = await ReportAlertHelper.getDiaColorApi(context: event.context);
    if (res != null) {
      listOfDiaColor = res;
    }

      if (HiveDataBase.pipelineDataBox!.values.isEmpty) {
        var res = await ReportAlertHelper.getPipelineApi(
          context: event.context,
          latitude: AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
          longitude:  AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
        );
        if (res != null && res.data != null) {
          listOfPipeline = res.data!;
        }
      }  else {
        listOfPipeline = await HiveDataBase.pipelineDataBox!.values.toList();
      }

    await   _filerPipe(context: event.context,emit: emit);
    _eventCompleted(emit);
  }

  Future<void> _initializeAllModels() async {
    isPipelineLoader = false;
    googleMapsUrl = "";
    await _clearTextField();
    points = [];
    listOfDiaColor = [];

    detailsTF = TFGISData();
    detailsValve = ValveGISData();
    detailsRegulator = RegulatorGISData();
    detailsCommercial = CommercialData();
    detailsDomestic = DomesticData();
    detailsIndustrial = IndustrialData();

    listOfTF = [];
    listOfValue = [];
    listOfRegulator = [];
    listOfCommercial = [];
    listOfDomestic = [];
    listOfIndustrial = [];

    listOfFilterTF = [];
    listOfFilterValue = [];
    listOfFilterRegulator = [];
    listOfFilterCommercial = [];
    listOfFilterDomestic = [];
    listOfFilterIndustrial = [];


    listOfTFId = [];
    listOfValveId = [];
    listOfRegulatorId = [];
    listOfDomesticId = [];
    listOfIndustrialId = [];
    listOfCommercialId = [];

    pipelineData = PipelineData();
    listOfPipeline = [];
    currentPosition = LatLng(0, 0);
    latLngOnTap = LatLng(0, 0);

    tempMarker = {};
    finalMarker = {};
    filterMarkerList = {};
    markersPointList = {};
    tfMarker = {};
    valveMarker = {};
    regularMarker = {};
    commercialMarker = {};
    domesticMarker = {};
    industrialMarker = {};
    filterPolyline = {};
    polylinePointList = {};
    pipePolylinePointList = {};
    allLatLongPoint = [];
    googleMapController = Completer();
    currentMapType = MapType.normal;
    role = await AppConfig.instanceInit()?.loginData.user?.role ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
  }


  _filerPipe({required BuildContext context,emit}) async {
    if (listOfPipeline.isNotEmpty) {
      finalPolyline.clear();
      finalMarker.clear();
      _eventCompleted(emit);
      for (int i = 0; i < listOfPipeline.length; i++) {
        pipelineData = listOfPipeline[i];
        if (pipelineData.geomencode != null &&
            pipelineData.geomencode!.isNotEmpty) {
          try {
            points = await DecodePolyline.decodePolyline(
              pipelineData.geomencode!,
            );
            final color = ReportAlertHelper.getPolylineColor(
              value: int.tryParse(pipelineData.nominaldia ?? '0') ?? 0,
              color: listOfDiaColor,
            );
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
      await _filterVisiblePolyline();
      await gotoInitialPosition(points[0]);

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

  gotoInitialPosition(LatLng location) async {
    position = CameraPosition(target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  _onCameraIdleEvent(OnCameraIdleEvent event, emit) async {
    await ReportAlertHelper.clearCache();
    _filterVisiblePolyline();
    _eventCompleted(emit);
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
          if (res != null && res.data != null) {
              listOfTF = res.data!;
          }
        } else {
          listOfTF = await HiveDataBase.tfGISBox!.values.toList();
        }
        if (listOfTF.isNotEmpty) {
          listOfTFId = listOfTF.map((e) => e.id ?? "").toList();
          final customIcon = await ReportAlertHelper.markerAsset(
            path: AssetPath.tf,
          );
          for (int i = 0; i < listOfTF.length; i++) {
            detailsTF = listOfTF[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsTF.latitude!),
                double.parse(detailsTF.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                icon: customIcon,
                position: latLngList,
                context: context,
                data: detailsTF,
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
          if (res != null && res.data != null) {
            listOfValue = res.data!;
          }
        } else {
          listOfValue = await HiveDataBase.valveGISBox!.values.toList();
        }
        if (listOfValue.isNotEmpty) {
          listOfValveId =
              listOfValue.map((e) => e.valveId ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            path: AssetPath.valve,
          );
          for (int i = 0; i < listOfValue.length; i++) {
            detailsValve = listOfValue[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsValve.latitude!),
                double.parse(detailsValve.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
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
          var res = await ReportAlertHelper.getRegulatorGisApi(context: context,);
          if (res != null && res.data != null) {
            listOfRegulator = res.data!;
          }
        } else {
          listOfRegulator = await HiveDataBase.regulatorGISBox!.values.toList();
        }
        if (listOfRegulator.isNotEmpty) {
          listOfRegulatorId =
              listOfRegulator.map((e) => e.id ?? "").toList();
          BitmapDescriptor customIcon = await ReportAlertHelper.markerAsset(
            path: AssetPath.regulator,
          );
          for (int i = 0; i < listOfRegulator.length; i++) {
            detailsRegulator = listOfRegulator[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsRegulator.latitude!),
                double.parse(detailsRegulator.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
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
          if (res != null && res.data != null) {
              listOfCommercial = res.data!;
          }
        } else {
          listOfCommercial = await HiveDataBase.commercialDataBox!.values.toList();
        }
        if (listOfCommercial.isNotEmpty) {
          listOfCommercialId = listOfCommercial.map((e) => e.id ?? "").toList();
          BitmapDescriptor dotCommercialIcon = BitmapDescriptor.bytes(
            await ReportAlertHelper.generateDotImage(color: Colors.deepOrangeAccent),
          );
          for (int i = 0; i < listOfCommercial.length; i++) {
            detailsCommercial = listOfCommercial[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsCommercial.latitude!),
                double.parse(detailsCommercial.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                icon: dotCommercialIcon,
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
          if (res != null && res.data != null) {
              listOfDomestic = res.data!;
          }
        } else {
          listOfDomestic = await HiveDataBase.domesticDataBox!.values.toList();
        }
        if (listOfDomestic.isNotEmpty) {
          listOfDomesticId = listOfDomestic.map((e) => e.id ?? "").toList();
          BitmapDescriptor dotDomesticIcon = BitmapDescriptor.bytes(
            await ReportAlertHelper.generateDotImage(color: Colors.yellowAccent),
          );
          for (int i = 0; i < listOfDomestic.length; i++) {
            detailsDomestic = listOfDomestic[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsDomestic.latitude!),
                double.parse(detailsDomestic.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                icon: dotDomesticIcon,
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
          if (res != null && res.data != null) {
            listOfIndustrial = res.data!;
          }
        } else {
          listOfIndustrial = await HiveDataBase.industrialDataBox!.values.toList();
        }
        if (listOfIndustrial.isNotEmpty) {
          listOfIndustrialId = listOfIndustrial.map((e) => e.id ?? "").toList();
          BitmapDescriptor dotDomesticIcon = BitmapDescriptor.bytes(
            await ReportAlertHelper.generateDotImage(color: Colors.blue.shade800),
          );
          for (int i = 0; i < listOfIndustrial.length; i++) {
            detailsIndustrial = listOfIndustrial[i];
            try {
              LatLng latLngList = LatLng(
                double.parse(detailsIndustrial.latitude!),
                double.parse(detailsIndustrial.longitude!),
              );
              Set<Marker> marker = ReportAlertHelper.markerPoint(
                icon: dotDomesticIcon,
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




  _selectGISValue({
    required List dataList,
    required TextEditingController controller,
    required BuildContext context,
    required BitmapDescriptor iconBytes,
    required List filteredList,
    required dynamic data,
     emit,
  }) async {
    filteredList.clear();
    _clearMarkerPolyline();

    if (controller.text.isNotEmpty) {
      filteredList.addAll(
        dataList.where((data) =>
        data.valveId.toString() == controller.text.toString()
        ).toList(),
      );
    } else {
      filteredList.addAll(dataList);
    }

    if (filteredList.isNotEmpty) {
      LatLng location = LatLng(
        double.parse(filteredList[0].latitude!),
        double.parse(filteredList[0].longitude!),
      );
      Set<Marker> markers = await ReportAlertHelper.markerPoint(
        position: location,
        context: context,
        icon: iconBytes,
        data: data,
      );
      tempMarker.clear();
      tempMarker.addAll(markers);
      markersPointList = Set.from(tempMarker);

      if (tempMarker.isNotEmpty) {
        GoogleMapController controller = await googleMapController.future;
        currentPosition = LatLng(
          tempMarker.first.position.latitude,
          tempMarker.first.position.longitude,
        );
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition, zoom: 17),
          ),
        );
        _updateMarkerPolyline();
      }
    }
    }


  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfTF,
      controller: tfGisController,
      context: event.context,
      iconBytes: await ReportAlertHelper.markerAsset(path: AssetPath.tf),
      filteredList: listOfFilterTF,
      data: detailsTF,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfValue,
      controller: valveController,
      context: event.context,
      iconBytes: await ReportAlertHelper.markerAsset(path: AssetPath.valve),
      filteredList: listOfFilterValue,
      data: detailsValve,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectRegulatorGISValue(SelectRegulatorGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfRegulator,
      controller: regulatorController,
      context: event.context,
      iconBytes: await ReportAlertHelper.markerAsset(path: AssetPath.regulator),
      filteredList: listOfFilterRegulator,
      data: detailsRegulator,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCommercialValue(SelectCommercialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfCommercial,
      controller: commercialController,
      context: event.context,
      iconBytes: BitmapDescriptor.bytes(await ReportAlertHelper.generateDotImage(color: Colors.deepOrangeAccent),),
      filteredList: listOfFilterCommercial,
      data: detailsCommercial,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectDomesticValue(SelectDomesticValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfDomestic,
      controller: domesticController,
      context: event.context,
      iconBytes:  BitmapDescriptor.bytes(await ReportAlertHelper.generateDotImage(color: Colors.yellowAccent),),
      filteredList: listOfFilterDomestic,
      data: detailsDomestic,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectIndustrial(SelectIndustrialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _selectGISValue(
      dataList: listOfIndustrial,
      controller: industrialController,
      context: event.context,
        iconBytes:  BitmapDescriptor.bytes(await ReportAlertHelper.generateDotImage(color: Colors.blue.shade800),),
      filteredList: listOfFilterIndustrial,
      data: detailsIndustrial,
        emit: emit
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    await _clearPopTextField();
    checkBoxTf = event.checkBoxTf;
    if (checkBoxTf == true) {
      isGasTfLoader = true;
      _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context, emit: emit);
    } else {
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
    } else {
      finalMarker.removeWhere((marker) => valveMarker.contains(marker));
      valveMarker.clear();
      _eventCompleted(emit);
    }
    isGasValveLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxRegulatorGis(SelectCheckBoxRegulatorGisEvent event, emit,) async {
    await _clearPopTextField();
    checkBoxRegulator = event.checkBoxRegulator;
    if (checkBoxRegulator == true) {
      isGasRegulatorLoader = true;
      _eventCompleted(emit);
      await _fetchGasRegulatorGisApi(context: event.context, emit: emit);
    } else {
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
      isCommercialLoader = true;
      _eventCompleted(emit);
      await _fetchCommercialApi(context: event.context, emit: emit);
    }else {
      finalMarker.removeWhere((marker) => commercialMarker.contains(marker));
      commercialMarker.clear();
      _eventCompleted(emit);
    }
    isCommercialLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckDomestic(SelectCheckDomesticEvent event, emit) async {
    await _clearPopTextField();
    checkDomestic = event.checkDomestic;
    if (checkDomestic == true) {
      isDomesticLoader = true;
      _eventCompleted(emit);
      await _fetchDomesticApi(context: event.context, emit: emit);
    }else {
      finalMarker.removeWhere((marker) => domesticMarker.contains(marker));
      domesticMarker.clear();
      _eventCompleted(emit);
    }
    isDomesticLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckIndustrial(SelectCheckIndustrialEvent event, emit) async {
    await _clearPopTextField();
    checkIndustrial = event.checkIndustrial;
    if (checkIndustrial == true) {
      isIndustrialLoader = true;
      _eventCompleted(emit);
      await _fetchIndustrialApi(context: event.context, emit: emit);
    }else {
      finalMarker.removeWhere((marker) => industrialMarker.contains(marker));
      industrialMarker.clear();
      _eventCompleted(emit);
    }
    isIndustrialLoader = false;
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
    nameofLocation =
        placemarks.isNotEmpty
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
              infoWindow: InfoWindow(title: 'Create Report Incident'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow,
              ),
              onTap: () async {
                if (polylinePointList.isNotEmpty) {
                  AppConfig.instanceInit()?.setData(newData: '');
                  AppConfig.instanceInit()?.setMarkerPoint(
                    newPointMarkerLat: event.latLngOnTap.latitude.toString(),
                    newPointMarkerLong: event.latLngOnTap.longitude.toString(),
                  );
                } else if (markersPointList.isNotEmpty) {
                  AppConfig.instanceInit()?.setMarkerPoint(
                    newPointMarkerLat: event.latLngOnTap.latitude.toString(),
                    newPointMarkerLong: event.latLngOnTap.longitude.toString(),
                  );
                }
                showDialog(
                  context: event.context,
                  builder:
                      (context) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: AlertDialogTwoBtnWidget(
                          mContext: context,
                          pipelineData: pipelineData,
                        ),
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
    isCommercialLoader = false;
    checkDomestic = false;
    isDomesticLoader = false;
    checkIndustrial = false;
    isIndustrialLoader = false;

    tfGisController.text = "";
    valveController.text = "";
    regulatorController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";
  }

  _clearPopTextField() {
    isGasTfLoader = false;
    isGasValveLoader = false;
    isGasRegulatorLoader = false;
    isCommercialLoader = false;
    isDomesticLoader = false;
    isIndustrialLoader = false;
    tfGisController.text = "";
    valveController.text = "";
    regulatorController.text = "";
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
        checkTf: checkBoxTf,
        isTfLoader: isGasTfLoader,
        checkValve: checkBoxValve,
        isValveLoader: isGasValveLoader,
        checkRegulator: checkBoxRegulator,
        isRegulatorLoader: isGasRegulatorLoader,

        checkCommercial: checkCommercial,
        isCommercialLoader: isCommercialLoader,
        checkDomestic: checkDomestic,
        isDomesticLoader: isDomesticLoader,
        checkIndustrial: checkIndustrial,
        isIndustrialLoader: isIndustrialLoader,

        baseUrl: baseUrl,
        nameofLocation: nameofLocation,
        role: role,
        position: position,
        googleMapController: googleMapController,
        currentMapType: currentMapType,
        markersPointList: Set.of(markersPointList),
        currentPosition: currentPosition,
        polylinePointList: Set.of(polylinePointList),
        tfController: tfGisController,
        valveController: valveController,
        regulatorController: regulatorController,
        commercialController: commercialController,
        domesticController: domesticController,
        industrialController: industrialController,
        listOfTfId: listOfTFId,
        listOfValveId: listOfValveId,
        listOfRegulatorId: listOfRegulatorId,
        listOfCommercialId: listOfCommercialId,
        listOfDomesticId: listOfDomesticId,
        listOfIndustrialId: listOfIndustrialId,
      ),
    );
  }
}
