import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/CurrentPosition/current_position.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/features/InChargeDashboard/Helper/in_charge_dashboard_helper.dart';
import 'package:outage_app/features/InChargeDashboard/domain/model/show_pipeline_model.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/presentation/widget/alert_dialog_details_widget.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/EmergencyModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/IndustrialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/ServiceModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/ValveGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/decodePolyline.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/incident_report_helper.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/report_marker_polyline.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/MapService.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/alert_dialog_widget.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/emergency_widget_report.dart';
import 'package:outage_app/features/Report/ReportOutage/presentation/widget/filter_report.dart';

import '../../../../Manage/IncidentDetails/domain/model/filter_key_enum.dart';
import 'incident_report_event.dart';
import 'incident_report_state.dart';

class IncidentReportBloc
    extends Bloc<IncidentReportEvent, IncidentReportState> {
  IncidentReportBloc() : super(IncidentReportInitialState()) {
    on<IncidentReportLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);

    on<SelectGoogleMapButtonEvent>(_selectGoogleMapButton);
    on<SelectGoogleRouteDirEvent>(_selectGoogleRouteDirEvent);
    on<SelectFilterButtonEvent>(_selectFilterButton);

    on<SelectCheckBoxTFGisEvent>(_selectCheckBoxTFGis);
    on<SelectTFGisEvent>(_selectTFGisValue);

    on<SelectCheckBoxValveGisEvent>(_selectCheckBoxValveGis);
    on<SelectValveGISValueEvent>(_selectValveGISValue);

    on<SelectCheckBoxServiceGisEvent>(_selectCheckBoxServiceGis);
    on<SelectServiceGISServiceEvent>(_selectServiceGISService);

    on<SelectCheckBoxRegulatorGisEvent>(_selectCheckBoxRegulatorGis);
    on<SelectRegulatorGISValueEvent>(_selectRegulatorGISValue);

    on<SelectCheckCommercialEvent>(_selectCheckCommercial);
    on<SelectCommercialValueEvent>(_selectCommercialValue);

    on<SelectCheckDomesticEvent>(_selectCheckDomestic);
    on<SelectDomesticValueEvent>(_selectDomesticValue);

    on<SelectCheckIndustrialEvent>(_selectCheckIndustrial);
    on<SelectIndustrialValueEvent>(_selectIndustrial);

    on<OnCameraIdleEvent>(_onCameraIdleEvent);
    on<OnMapCreatedEvent>(_onMapCreatedEvent);
    on<ResetFilterEvent>(_onResetFilterEvent);

    on<CurrentLocationEvent>(_currentLocationEvent);
    on<UpdateStartAddressEvent>(_updateStartAddress);
    on<SelectCurrentSuggestionEvent>(_selectCurrentSuggestion);
    on<UpdateDestinationAddressEvent>(_updateDestinationAddress);
    on<SelectDestinationSuggestionEvent>(_selectDestinationSuggestion);
    on<ShowRouteButtonEvent>(_showRouteButtonEvent);
    on<SearchHideShowEvent>(_searchHideShowEvent);
    on<SelectEmergencyEvent>(_selectEmergency);
    on<SelectSearchEmergencyEvent>(_searchEmergencyHospital);
    on<StopTimerEvent>(_stopTimer);
    on<RefreshEvent>(_selectRefreshEvent);
  }

  bool isLoader = false;
  bool isRefresh = false;
  bool isMapDir = false;
  bool isVisible = false;
  bool isPipelineLoader = false;
  bool checkTf = false;
  bool isTFLoader = false;
  bool checkValve = false;
  bool checkService = false;
  bool isValveLoader = false;

  bool isServiceLoader = false;
  bool checkRegulator = false;
  bool isRegulatorLoader = false;
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
  String startAddress = '';
  String destinationAddress = '';
  String placeDistance = "";

  Set<Marker> blinkMarkerList = {};
  final TextEditingController tfGisController = TextEditingController();
  final TextEditingController valveController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController regulatorController = TextEditingController();
  final TextEditingController commercialController = TextEditingController();
  final TextEditingController domesticController = TextEditingController();
  final TextEditingController industrialController = TextEditingController();
  final TextEditingController startAddressController = TextEditingController();
  final TextEditingController destinationAddressController =
      TextEditingController();
  final TextEditingController emergencyController = TextEditingController();

  List<ShowPipelineModel> showPipelineModel = [];

  List<TFGISData> listOfTF = [];
  List<String> listOfTFId = [];

  List<ValveGISData> listOfValue = [];
  List<String> listOfValveId = [];

  List<ServiceData> listOfService = [];
  List<String> listOfServiceId = [];

  List<RegulatorGISData> listOfRegulator = [];
  List<String> listOfRegulatorId = [];

  List<CommercialData> listOfCommercial = [];
  List<String> listOfCommercialId = [];

  List<DomesticData> listOfDomestic = [];
  List<String> listOfDomesticId = [];

  List<IndustrialData> listOfIndustrial = [];
  List<String> listOfIndustrialId = [];

  List<EmergencyData> listOfEmergencyData = [];
  List<String> listOfEmergencyId = [];

  Map<String, String> diaColors = {};
  List<dynamic> curPlaceList = [];
  List<dynamic> desPlaceList = [];

  PipelineData pipelineData = PipelineData();
  List<PipelineData> listOfPipeline = [];

  LatLng currentPosition = LatLng(0, 0);
  LatLng latLngOnTap = LatLng(0, 0);
  List<LatLng> points = [];

  Set<Marker> tempMarker = {};
  Set<Marker> filterMarkerList = {};
  Set<Marker> finalMarker = {};
  Set<Marker> tfMarker = {};
  Set<Marker> valveMarker = {};
  Set<Marker> serviceMarker = {};
  Set<Marker> regularMarker = {};
  Set<Marker> commercialMarker = {};
  Set<Marker> domesticMarker = {};
  Set<Marker> industrialMarker = {};
  Set<Marker> markersPointList = {};
  Set<Marker> routePointList = {};

  Set<Marker> refreshMarkerList = {};
  Set<Polyline> refreshPolylineList = {};

  Set<Polyline> polylinePointList = {};
  Set<Polyline> routePolyline = {};
  Set<Polyline> pipePolylinePointList = {};
  Set<Polyline> filterPolyline = {};
  Set<Polyline> finalPolyline = {};
  List<LatLng> polylineCoordinates = [];
  MapType currentMapType = MapType.normal;

  Completer<GoogleMapController> googleMapController = Completer();

  bool isBlinkMarker = true;
  Timer blinkTimer = Timer(Duration.zero, () {});

  final mapService = MapService();

  _pageLoad(IncidentReportLoadEvent event, emit) async {
    emit(IncidentReportPageLoadState());
    isLoader = false;
    isRefresh = false;
    isMapDir = false;
    isVisible = false;
    isPipelineLoader = false;
    checkTf = false;
    isTFLoader = false;
    checkValve = false;
    isValveLoader = false;
    checkService = false;
    isServiceLoader = false;
    checkRegulator = false;
    isRegulatorLoader = false;
    checkCommercial = false;
    isCommercialLoader = false;
    checkDomestic = false;
    isDomesticLoader = false;
    checkIndustrial = false;
    isIndustrialLoader = false;
    role = '';
    baseUrl = '';
    nameofLocation = '';
    googleMapsUrl = "";
    startAddress = '';
    destinationAddress = '';
    placeDistance = "";

    blinkMarkerList = {};
    tfGisController.text = "";
    valveController.text = "";
    serviceController.text = "";
    regulatorController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";
    startAddressController.text = "";
    destinationAddressController.text = "";
    emergencyController.text = "";

    showPipelineModel = [];
    refreshPolylineList = {};
    refreshMarkerList = {};

    listOfTF = [];
    listOfTFId = [];

    listOfValue = [];
    listOfValveId = [];

    listOfService = [];
    listOfServiceId = [];

    listOfRegulator = [];
    listOfRegulatorId = [];

    listOfCommercial = [];
    listOfCommercialId = [];

    listOfDomestic = [];
    listOfDomesticId = [];

    listOfIndustrial = [];
    listOfIndustrialId = [];

    listOfEmergencyData = [];
    listOfEmergencyId = [];

    diaColors = {};
    curPlaceList = [];
    desPlaceList = [];

    pipelineData = PipelineData();
    listOfPipeline = [];
    final ctx = await UserContext.getUserContext();
    log("HO User: ${ctx.isHo}");
    currentPosition = LatLng(
      double.parse(ctx.user.gaLatitude ?? "0.0"),
      double.parse(ctx.user.gaLongitude ?? "0.0"),
    );
    latLngOnTap = LatLng(0, 0);
    points = [];

    tempMarker = {};
    filterMarkerList = {};
    finalMarker = {};
    tfMarker = {};
    valveMarker = {};
    serviceMarker = {};
    regularMarker = {};
    commercialMarker = {};
    domesticMarker = {};
    industrialMarker = {};
    markersPointList = {};

    polylinePointList = {};
    pipePolylinePointList = {};
    filterPolyline = {};
    finalPolyline = {};
    polylineCoordinates = [];
    currentMapType = MapType.normal;

    googleMapController = Completer();

    isBlinkMarker = true;
    blinkTimer = Timer(Duration.zero, () {});
    final client = await  AppConfig.instanceInit()!.client;
    final isMGL = client == Client.mahaNagar;
    final isHPCL = client == Client.hpcl;

    var icons = await ReportMarkerPolyline.markerAsset(path: "");
    await _searchFilter(
      searchText: "",
      dataList: [],
      context: event.context,
      iconBytes: icons,
      filterByKey: FilterKey.ID,
      emit: emit,
    );
    var res = await IncidentReportHelper.getDiaColorApi(context: event.context);
    if (res != null) {
      diaColors = res;
      await AppConfig.instanceInit()?.setDiaColor(newDiaColors: diaColors);
    }

    await _fetchEmergency(context: event.context);
    await _filerPipe(context: event.context, emit: emit);
    if (isMGL || isHPCL) {
      await _fetchDrowPipeLine(context: event.context);
      _eventCompleted(emit);
    }
    _eventCompleted(emit);
  }

  _fetchEmergency({required BuildContext context}) async {
    var res = await IncidentReportHelper.getEmergencySearchApi(
      context: context,
    );
    if (res != null && res.data != null && res.data!.isNotEmpty) {
      listOfEmergencyData = res.data!;
      listOfEmergencyId =
          listOfEmergencyData.map((e) => e.emergencyName).toList();
    }
  }

  _fetchDrowPipeLine({required BuildContext context}) async {
    final res = await InChargeDashboardHelper.fetchShowPipelineData(
      context: context,
    );
    if (res != null) {
      showPipelineModel = [res];
      await _rebuildOverlays(context: context);
    }
  }

  _filerPipe({required BuildContext context, emit}) async {
    final pipelineBox = HiveDataBase.pipelineDataBox;
    if (pipelineBox == null || pipelineBox.values.isEmpty) {
      var res = await IncidentReportHelper.getPipelineApi(
        context: context,
        latitude:
            AppConfig.instanceInit()!.loginData.user!.gaLatitude.toString(),
        longitude:
            AppConfig.instanceInit()!.loginData.user!.gaLongitude.toString(),
      );
      if (res != null && res.data != null && res.data!.isNotEmpty) {
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
        if (pipelineData.geomencode != null &&
            pipelineData.geomencode!.isNotEmpty) {
          try {
            points = await DecodePolyline.decodePolyline(
              pipelineData.geomencode!,
            );
            final color = ReportMarkerPolyline.getPolylineColor(
              value: int.tryParse(pipelineData.nominaldia ?? '0') ?? 0,
              colorMap: diaColors,
            );
            Set<Polyline> polyline = ReportMarkerPolyline.polylinePoint(
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
      await _gotoInitialPosition(points[0]);
    }
  }

  Future<void> _selectRefreshEvent(RefreshEvent event, emit) async {
    try {
      isRefresh = true;
      _eventCompleted(emit);
      await _fetchDrowPipeLine(context: event.context);
      isRefresh = false;
      _eventCompleted(emit);
    } catch (_) {
      // TODO: surface error to UI via a dedicated error state
    } finally {
      isRefresh = false;
      _eventCompleted(emit);
    }
  }

  Future<void> _rebuildOverlays({required BuildContext context}) async {
    // ✅ Clear previous refresh data first
    refreshPolylineList.clear();
    refreshMarkerList.clear();

    final markerFutures = <Future<Marker>>[];

    for (final pipeline in showPipelineModel) {
      if (pipeline.polylines?.isNotEmpty ?? false) {
        // ✅ Store in dedicated refresh set, NOT polylinePointList
        refreshPolylineList.addAll(
          ReportMarkerPolyline.toPolylineSet(pipeline.polylines!),
        );
      }
      // ✅ Markers with onTap add karo
      if (pipeline.markers?.isNotEmpty ?? false) {
        for (final m in pipeline.markers!) {
          final lat = m.point?.lat?.toDouble();
          final lng = m.point?.lng?.toDouble();
          if (lat == null || lng == null) continue;

          final markerLatLng = LatLng(lat, lng); // ✅ marker ki actual position

          final markerWithTap = await ReportMarkerPolyline.createMarker(
            marker: m,
            onTap: () async {
              final currentPoint = await mapService.getCurrentLocation(
                context: context,
              );
              if (currentPoint == null) return;

              // ✅ State update karo
              latLngOnTap = markerLatLng;
              isMapDir = true;
              googleMapsUrl = mapService.buildGoogleMapsUrl(
                currentPoint,
                markerLatLng,
              );
              nameofLocation = (await MapService.getAddress(latLng: markerLatLng)) ?? '';

              Set<Marker> tempMarker = Set.from(markersPointList);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: AlertDialogDetailsWidgetWidget(
                     pipelineData: pipelineData,
                    currLatLng: markerLatLng,
                  ),
                ),
              );
              markersPointList = tempMarker;

            },
          );
          refreshMarkerList.add(markerWithTap);
          markersPointList.add(markerWithTap);
        }
      }
    }

    // ✅ Store in dedicated refresh set, NOT markersPointList
    refreshMarkerList.addAll(await Future.wait(markerFutures));
  }

  _fetchTFGisApi({required BuildContext context, emit}) async {
    if (checkTf == true) {
      try {
        final tfBox = HiveDataBase.tfGISBox;
        if (tfBox == null || tfBox.values.isEmpty) {
          var res = await IncidentReportHelper.getTFGisApi(context: context);
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfTF = res.data!;
          }
        } else {
          listOfTF = tfBox.values.toList();
        }

        if (listOfTF.isNotEmpty) {
          listOfTFId = listOfTF.map((e) => e.tfNumber ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfTF,
            assetPath: AssetPath.tf,
            targetMarkerSet: tfMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.ID,
          );
        }
      } catch (e) {
        print("Error during TFGis API fetching: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchGasValueGisApi({required BuildContext context, emit}) async {
    if (checkValve == true) {
      try {
        final valveBox = HiveDataBase.valveGISBox;
        if (valveBox == null || valveBox.values.isEmpty) {
          var res = await IncidentReportHelper.getGasValueGisApi(
            context: context,
          );
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfValue = res.data!;
          }
        } else {
          listOfValue = valveBox.values.toList();
        }

        if (listOfValue.isNotEmpty) {
          listOfValveId = listOfValue.map((e) => e.valveId ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfValue,
            assetPath: AssetPath.valve,
            targetMarkerSet: valveMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.VALUE_ID,
          );
        }
      } catch (e) {
        print("Error during Gas Valve GIS API fetching: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchGasServiceGisApi({required BuildContext context, emit}) async {
    if (checkService == true) {
      try {
        final serviceBox = HiveDataBase.serviceGISBox;
        if (serviceBox == null || serviceBox.values.isEmpty) {
          var res = await IncidentReportHelper.getGasServiceGisApi(context: context);
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfService = res.data!;
          }
        } else {
          listOfService = serviceBox.values.toList();
        }

        if (listOfService.isNotEmpty) {
          listOfServiceId = listOfService.map((e) => e.servicePointId ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfService,
            assetPath: AssetPath.service,
            targetMarkerSet: serviceMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.SERVICE_ID,
          );
        }
      } catch (e) {
        print("Error during Gas SERVICE GIS API fetching: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchGasRegulatorGisApi({required BuildContext context, emit}) async {
    if (checkRegulator == true) {
      try {
        final regulatorBox = HiveDataBase.regulatorGISBox;

        if (regulatorBox == null || regulatorBox.values.isEmpty) {
          var res = await IncidentReportHelper.getRegulatorGisApi(context: context);
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfRegulator = res.data!;
          }
        } else {
          listOfRegulator = regulatorBox.values.toList();
        }

        if (listOfRegulator.isNotEmpty) {
          listOfRegulatorId =
              listOfRegulator.map((e) => e.regulatorid ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfRegulator,
            assetPath: AssetPath.regulator,
            targetMarkerSet: regularMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.RegulatorId,
          );
        }
      } catch (e) {
        print("Error _fetchGasRegulatorGisApi: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchCommercialApi({required BuildContext context, emit}) async {
    if (checkCommercial == true) {
      try {
        final commercialBox = HiveDataBase.commercialDataBox;

        if (commercialBox == null || commercialBox.values.isEmpty) {
          var res = await IncidentReportHelper.getCommercialApi(
            context: context,
          );
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfCommercial = res.data!;
          }
        } else {
          listOfCommercial = commercialBox.values.toList();
        }

        if (listOfCommercial.isNotEmpty) {
          listOfCommercialId =
              listOfCommercial.map((e) => e.bpNumber ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfCommercial,
            dotColor: Colors.deepOrangeAccent,
            targetMarkerSet: commercialMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.BP_NUMBER,
          );
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchDomesticApi({required BuildContext context, emit}) async {
    if (checkDomestic == true) {
      final domesticBox = HiveDataBase.domesticDataBox;

      if (domesticBox == null || domesticBox.values.isEmpty) {
        var res = await IncidentReportHelper.getDomesticApi(context: context);
        if (res != null && res.data != null && res.data!.isNotEmpty) {
          listOfDomestic = res.data!;
        }
      } else {
        listOfDomestic = domesticBox.values.toList();
      }
      if (listOfDomestic.isNotEmpty) {
        listOfDomesticId = listOfDomestic.map((e) => e.bpNumber ?? "").toList();
        await ReportMarkerPolyline.processMarkersInBatches(
          context: context,
          dataList: listOfDomestic,
          dotColor: Colors.yellowAccent,
          targetMarkerSet: domesticMarker,
          finalMarker: finalMarker,
          filterByKey: FilterKey.BP_NUMBER,
        );
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _fetchIndustrialApi({required BuildContext context, emit}) async {
    if (checkIndustrial == true) {
      try {
        final industrialBox = HiveDataBase.industrialDataBox;

        if (industrialBox == null || industrialBox.values.isEmpty) {
          var res = await IncidentReportHelper.getIndustrialApi(
            context: context,
          );
          if (res != null && res.data != null && res.data!.isNotEmpty) {
            listOfIndustrial = res.data!;
          }
        } else {
          listOfIndustrial = industrialBox.values.toList();
        }

        if (listOfIndustrial.isNotEmpty) {
          listOfIndustrialId =
              listOfIndustrial.map((e) => e.bpNumber ?? "").toList();
          await ReportMarkerPolyline.processMarkersInBatches(
            context: context,
            dataList: listOfIndustrial,
            dotColor: Colors.blue.shade800,
            targetMarkerSet: industrialMarker,
            finalMarker: finalMarker,
            filterByKey: FilterKey.BP_NUMBER,
          );
        }
      } catch (e) {
        print("Error during Gas Consumer GIS API fetching: $e");
      }
    }
    _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _selectTFGisValue(SelectTFGisEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.tfGisId,
      dataList: listOfTF,
      context: event.context,
      iconBytes: await ReportMarkerPolyline.markerAsset(path: AssetPath.tf),
      filterByKey: FilterKey.ID,
      emit: emit,
    );

    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectValveGISValue(SelectValveGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.gasValveGISId,
      dataList: listOfValue,
      context: event.context,
      iconBytes: await ReportMarkerPolyline.markerAsset(path: AssetPath.valve),
      filterByKey: FilterKey.VALUE_ID,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectServiceGISService(SelectServiceGISServiceEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.gasServiceGISId,
      dataList: listOfService,
      context: event.context,
      iconBytes: await ReportMarkerPolyline.markerAsset(
        path: AssetPath.service,
      ),
      filterByKey: FilterKey.SERVICE_ID,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectRegulatorGISValue(SelectRegulatorGISValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.gasRegulatorGISId,
      dataList: listOfRegulator,
      context: event.context,
      iconBytes: await ReportMarkerPolyline.markerAsset(
        path: AssetPath.regulator,
      ),
      filterByKey: FilterKey.RegulatorId,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCommercialValue(SelectCommercialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.commercialId,
      dataList: listOfCommercial,
      context: event.context,
      iconBytes: BitmapDescriptor.bytes(
        await ReportMarkerPolyline.generateDotImage(
          color: Colors.deepOrangeAccent,
        ),
      ),
      filterByKey: FilterKey.BP_NUMBER,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectDomesticValue(SelectDomesticValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.domesticId,
      dataList: listOfDomestic,
      context: event.context,
      iconBytes: BitmapDescriptor.bytes(
        await ReportMarkerPolyline.generateDotImage(color: Colors.yellowAccent),
      ),
      filterByKey: FilterKey.BP_NUMBER,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectIndustrial(SelectIndustrialValueEvent event, emit) async {
    isPipelineLoader = true;
    _eventCompleted(emit);
    await _searchFilter(
      searchText: event.industrialId,
      dataList: listOfIndustrial,
      context: event.context,
      iconBytes: BitmapDescriptor.bytes(
        await ReportMarkerPolyline.generateDotImage(
          color: Colors.blue.shade800,
        ),
      ),
      filterByKey: FilterKey.BP_NUMBER,
      emit: emit,
    );
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectCheckBoxTFGis(SelectCheckBoxTFGisEvent event, emit) async {
    checkTf = event.checkBoxTf;
    if (checkTf == true) {
      isTFLoader = true;
      _eventCompleted(emit);
      await _fetchTFGisApi(context: event.context, emit: emit);
      isTFLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => tfMarker.contains(marker));
      tfMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckBoxValveGis(SelectCheckBoxValveGisEvent event, emit) async {
    checkValve = event.checkBoxValve;
    if (checkValve == true) {
      isValveLoader = true;
      _eventCompleted(emit);
      await _fetchGasValueGisApi(context: event.context, emit: emit);
      isValveLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => valveMarker.contains(marker));
      valveMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckBoxServiceGis(SelectCheckBoxServiceGisEvent event, emit) async {
    checkService = event.checkBoxService;
    if (checkService == true) {
      isServiceLoader = true;
      _eventCompleted(emit);
      await _fetchGasServiceGisApi(context: event.context, emit: emit);
      isServiceLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => serviceMarker.contains(marker));
      serviceMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckBoxRegulatorGis(
    SelectCheckBoxRegulatorGisEvent event,
    emit,
  ) async {
    checkRegulator = event.checkBoxRegulator;
    if (checkRegulator == true) {
      isRegulatorLoader = true;
      _eventCompleted(emit);
      await _fetchGasRegulatorGisApi(context: event.context, emit: emit);
      isRegulatorLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => regularMarker.contains(marker));
      regularMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckCommercial(SelectCheckCommercialEvent event, emit) async {
    checkCommercial = event.checkCommercial;
    if (checkCommercial == true) {
      isCommercialLoader = true;
      _eventCompleted(emit);
      await _fetchCommercialApi(context: event.context, emit: emit);
      isCommercialLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => commercialMarker.contains(marker));
      commercialMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckDomestic(SelectCheckDomesticEvent event, emit) async {
    checkDomestic = event.checkDomestic;
    if (checkDomestic == true) {
      isDomesticLoader = true;
      _eventCompleted(emit);
      await _fetchDomesticApi(context: event.context, emit: emit);
      isDomesticLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => domesticMarker.contains(marker));
      domesticMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectCheckIndustrial(SelectCheckIndustrialEvent event, emit) async {
    checkIndustrial = event.checkIndustrial;
    if (checkIndustrial == true) {
      isIndustrialLoader = true;
      _eventCompleted(emit);
      await _fetchIndustrialApi(context: event.context, emit: emit);
      isIndustrialLoader = false;
      _eventCompleted(emit);
    } else {
      finalMarker.removeWhere((marker) => industrialMarker.contains(marker));
      industrialMarker.clear();
    }
    _eventCompleted(emit);
  }

  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _eventCompleted(emit);
  }

  _currentPointMarker({required BuildContext context}) async {
    LatLng? currentPoint = await mapService.getCurrentLocation(
      context: context,
    );
    if (currentPoint != null) {
      GoogleMapController controller = await googleMapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentPoint.latitude, currentPoint.longitude),
            zoom: 18.0,
          ),
        ),
      );
      final address = await CurrentLocation.getAddress();
      startAddressController.text = address ?? '';
      print("startAddressController.text ===> ${startAddressController.text}");
    }
  }

  _searchFilter({
    required List dataList,
    required BuildContext context,
    required BitmapDescriptor iconBytes,
    required String searchText,
    required emit,
    required FilterKey filterByKey,
  }) async {
    if (searchText.isNotEmpty) {
      var filterData = dataList.where((data) {
            switch (filterByKey) {
              case FilterKey.VALUE_ID:
                return data.valveId.toString() == searchText;
              case FilterKey.SERVICE_ID:
                return data.servicePointId.toString() == searchText;
              case FilterKey.BP_NUMBER:
                return data.bpNumber.toString() == searchText;
              case FilterKey.ID:
                return data.id.toString() == searchText;
              case FilterKey.RegulatorId:
                return data.regulatorid.toString() == searchText;
            }
          }).first;

      LatLng location = LatLng(
        double.parse(filterData.latitude!),
        double.parse(filterData.longitude!),
      );

      GoogleMapController controllerMap = await googleMapController.future;
      currentPosition = location;

      await controllerMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 19),
        ),
      );
      final searchMarker = await ReportMarkerPolyline.markerPoint(
        position: location,
        context: context,
        icon: iconBytes,
        data: filterData,
        filterByKey: filterByKey,
        searchText: searchText,
      );
      markersPointList.clear();
      blinkMarkerList.clear();
      blinkMarkerList.addAll(searchMarker);

      _restartBlinking();
    } else {
      AppConfig.instanceInit()?.setData(newData: '');
    }
    _eventCompleted(emit);
  }

  _selectGoogleMapButton(SelectGoogleMapButtonEvent event, emit) async {
    final currentPoint = await mapService.getCurrentLocation(
      context: event.context,
    );
    if (currentPoint != null) {
      latLngOnTap = event.latLngOnTap;
      isMapDir = true;
      googleMapsUrl = mapService.buildGoogleMapsUrl(currentPoint, latLngOnTap);
      print("googleMapsUrl --> $googleMapsUrl");
      nameofLocation = (await MapService.getAddress(latLng: event.latLngOnTap))!;
      print("nameofLocation --> $nameofLocation");
      Set<Marker> tempMarker = Set.from(markersPointList);
      if (mapService.isPointNearAnyPolyline(event.latLngOnTap, polylinePointList,)) {
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
                        pipelineData: pipelineData,
                        currLatLng: event.latLngOnTap,
                      ),
                    ),
              );
            },
          ),
        );
      }
      markersPointList = tempMarker;
      _eventCompleted(emit);
    }
  }

  _selectGoogleRouteDirEvent(SelectGoogleRouteDirEvent event, emit) async {
    final currentPoint = await mapService.getCurrentLocation(
      context: event.context,
    );
    if (currentPoint != null) {
      latLngOnTap = event.toLatLng;
      isMapDir = true;
      googleMapsUrl = mapService.buildGoogleMapsUrl(currentPoint, latLngOnTap);
      print("googleMapsUrl--->${googleMapsUrl}");
    }
    await mapService.launchExternalUrl(googleMapsUrl);
    _eventCompleted(emit);
  }

  _onResetFilterEvent(ResetFilterEvent event, emit) async {
    tempMarker = {};
    await _gotoInitialPosition(points[0]);
    _clearTextField();
    _clearMarkerPolyline();
    Navigator.pop(event.context, true);
    _eventCompleted(emit);
  }

  _gotoInitialPosition(LatLng location) async {
    CameraPosition cameraPosition = CameraPosition(target: location);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  _onCameraIdleEvent(OnCameraIdleEvent event, emit) async {
    //  await IncidentReportHelper.clearCache();
    await _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  // Handler - fires AFTER controller is ready
  FutureOr<void> _onMapCreatedEvent(OnMapCreatedEvent event, emit) async {
    // Wait a frame so getVisibleRegion() returns correct bounds
    await Future.delayed(const Duration(milliseconds: 300));
    await _filterVisiblePolyline();
    _eventCompleted(emit);
  }

  _currentLocationEvent(CurrentLocationEvent event, emit) async {
    await _currentPointMarker(context: event.context);
    _eventCompleted(emit);
  }

  _updateStartAddress(UpdateStartAddressEvent event, emit) async {
    startAddressController.text = event.startAddress;
    curPlaceList = [];
    if (startAddressController.text.isNotEmpty) {
      print("=============================${startAddressController.text}");
      final res = await IncidentReportHelper.getSuggestion(
        input: event.startAddress,
      );
      curPlaceList = res;
    }
    _eventCompleted(emit);
  }

  _selectCurrentSuggestion(SelectCurrentSuggestionEvent event, emit) async {
    startAddressController.text = event.selectedCurrent;
    curPlaceList = [];
    _eventCompleted(emit);
  }

  _updateDestinationAddress(UpdateDestinationAddressEvent event, emit) async {
    destinationAddressController.text = event.destinationAddress;
    desPlaceList = [];
    if (destinationAddressController.text.isNotEmpty) {
      print(
        "=============================${destinationAddressController.text}",
      );
      final res = await IncidentReportHelper.getSuggestion(
        input: event.destinationAddress,
      );
      desPlaceList = res;
    }
    _eventCompleted(emit);
  }

  _selectDestinationSuggestion(
    SelectDestinationSuggestionEvent event,
    emit,
  ) async {
    destinationAddressController.text = event.selectedDescription;
    desPlaceList = [];
    _eventCompleted(emit);
  }

  _searchHideShowEvent(SearchHideShowEvent event, emit) {
    isVisible = !isVisible;
    print("isVisible-->${isVisible}");
    _eventCompleted(emit);
  }

  _showRouteButtonEvent(ShowRouteButtonEvent event, emit) async {
    final controller = await googleMapController.future;
    Set<Marker> makeMarkers = Set.from(markersPointList);
    Set<Polyline> makePolyline = Set.from(polylinePointList);
    if (startAddressController.text.isNotEmpty &&
        destinationAddressController.text.isNotEmpty) {
      List<Location> startPlacemark = await locationFromAddress(
        startAddressController.text,
      );
      List<Location> destPlacemark = await locationFromAddress(
        destinationAddressController.text,
      );

      double startLat = startPlacemark[0].latitude;
      double startLng = startPlacemark[0].longitude;
      double destLat = destPlacemark[0].latitude;
      double destLng = destPlacemark[0].longitude;
      double minLat = startLat < destLat ? startLat : destLat;
      double minLng = startLng < destLng ? startLng : destLng;
      double maxLat = startLat > destLat ? startLat : destLat;
      double maxLng = startLng > destLng ? startLng : destLng;
      // Add markers
      makeMarkers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(startLat, startLng),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: startAddressController.text,
          ),
        ),
      );
      makeMarkers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(destLat, destLng),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: destinationAddressController.text,
          ),
        ),
      );
      routePointList = makeMarkers;
      // Calculate route & polyline
      final result = await MapService.createPolylines(
        startLat: startLat,
        startLng: startLng,
        destLat: destLat,
        destLng: destLng,
        polylines: makePolyline,
        polylineCoordinates: polylineCoordinates,
      );
      routePolyline = makePolyline;
      // Optional: calculate distance based on polyline points
      double totalDistance = 0.0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 25));
      isVisible = false;
      _updateMarkerPolyline();
      _eventCompleted(emit);
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
    polylinePointList = {
      ...pipePolylinePointList,
      ...filterPolyline,
      ...routePolyline,
      ...refreshPolylineList, // ✅ always included on every update
    };
    markersPointList = {
      ...markersPointList,
      ...filterMarkerList,
      ...routePointList,
      ...refreshMarkerList, // ✅ always included on every update
    };
    print("pipePolylinePointList-->${pipePolylinePointList.length}");
    print("filterPolyline-->${filterPolyline.length}");
    print("markersPointList-->${markersPointList.length}");
    print("filterMarkerList-->${filterMarkerList.length}");
  }

  _selectFilterButton(SelectFilterButtonEvent event, emit) async {
    await _clearPopTextField();
    await showDialog(
      context: event.context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<IncidentReportBloc>(context),
          child: ReportPopWidget(mContext: event.context),
        );
      },
    );
    _eventCompleted(emit);
  }

  _selectEmergency(SelectEmergencyEvent event, emit) async {
    await showDialog(
      context: event.context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: BlocProvider.of<IncidentReportBloc>(context),
          child: EmergencyWidgetReport(),
        );
      },
    );
    _eventCompleted(emit);
  }

  _searchEmergencyHospital(SelectSearchEmergencyEvent event, emit) async {
    final selected = listOfEmergencyData.firstWhere(
      (e) => e.emergencyName == event.searchEmergency,
    );

    final lat = double.tryParse(selected.latitude);
    final lng = double.tryParse(selected.longitude);

    final targetPosition = LatLng(lat!, lng!);

    GoogleMapController controllerMap = await googleMapController.future;

    await controllerMap.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: targetPosition, zoom: 19),
      ),
    );
    Set<Marker> emergencyMarker = Set.from(markersPointList);
    emergencyMarker.add(
      Marker(
        markerId: MarkerId('selected_emergency'),
        position: targetPosition,
        infoWindow: InfoWindow(title: selected.emergencyName),
      ),
    );
    filterMarkerList = emergencyMarker;
    _eventCompleted(emit);
  }

  _clearTextField() async {
    checkTf = false;
    isTFLoader = false;
    checkValve = false;
    isValveLoader = false;
    isServiceLoader = false;
    checkService = false;
    checkRegulator = false;
    isRegulatorLoader = false;
    checkCommercial = false;
    isCommercialLoader = false;
    checkDomestic = false;
    isDomesticLoader = false;
    checkIndustrial = false;
    isIndustrialLoader = false;

    tfGisController.text = "";
    valveController.text = "";
    serviceController.text = "";
    regulatorController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";
    startAddressController.text = "";
    destinationAddressController.text = "";
    emergencyController.text = "";
  }

  _clearPopTextField() {
    isTFLoader = false;
    isValveLoader = false;
    isServiceLoader = false;
    isRegulatorLoader = false;
    isCommercialLoader = false;
    isDomesticLoader = false;
    isIndustrialLoader = false;
    tfGisController.text = "";
    valveController.text = "";
    serviceController.text = "";
    regulatorController.text = "";
    commercialController.text = "";
    domesticController.text = "";
    industrialController.text = "";
    startAddressController.text = "";
    destinationAddressController.text = "";
    emergencyController.text = "";
  }

  _clearMarkerPolyline() {
    polylinePointList = {};
    markersPointList = {};
    filterPolyline = {};
    filterMarkerList = {};
    refreshPolylineList = {}; // ✅ clear refresh too
    refreshMarkerList = {}; // ✅ clear refresh too
    polylinePointList = {...pipePolylinePointList};
    markersPointList = {...markersPointList};
  }

  @override
  Future<void> close() {
    blinkTimer.cancel();
    return super.close();
  }

  void _restartBlinking() {
    if (blinkTimer.isActive == true) {
      blinkTimer.cancel();
    }
    isBlinkMarker = true;
    _startBlinking();
  }

  FutureOr<void> _stopTimer(
    StopTimerEvent event,
    Emitter<IncidentReportState> emit,
  ) {
    if (blinkTimer.isActive) {
      blinkTimer.cancel();
    }
  }

  _startBlinking() async {
    final controller = await googleMapController.future;
    blinkTimer.cancel();
    blinkTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (isBlinkMarker) {
        markersPointList.addAll(blinkMarkerList);
        Future.delayed(Duration(milliseconds: 200), () {
          final blink = blinkMarkerList.first;
          controller.showMarkerInfoWindow(blink.markerId);
        });
      } else {
        final blink = blinkMarkerList.first;
        controller.hideMarkerInfoWindow(blink.markerId);
        markersPointList.removeWhere(
          (element) => element.markerId == blink.markerId,
        );
      }
      isBlinkMarker = !isBlinkMarker;
      emit(IncidentReportPageLoadState());
      emit(
        FetchIncidentReportDataState(
          isLoader: isLoader,
          isRefresh: isRefresh,
          isMapDir: isMapDir,
          isVisible: isVisible,
          isPipelineLoader: isPipelineLoader,
          checkTf: checkTf,
          isTfLoader: isTFLoader,
          checkValve: checkValve,
          checkService: checkService,
          isValveLoader: isValveLoader,
          isServiceLoader: isServiceLoader,
          checkRegulator: checkRegulator,
          isRegulatorLoader: isRegulatorLoader,

          checkCommercial: checkCommercial,
          isCommercialLoader: isCommercialLoader,
          checkDomestic: checkDomestic,
          isDomesticLoader: isDomesticLoader,
          checkIndustrial: checkIndustrial,
          isIndustrialLoader: isIndustrialLoader,
          startAddress: startAddress,
          destinationAddress: destinationAddress,
          placeDistance: placeDistance,
          baseUrl: baseUrl,
          nameofLocation: nameofLocation,
          role: role,
          googleMapController: googleMapController,
          currentMapType: currentMapType,
          markersPointList: Set.of(markersPointList),
          currentPosition: currentPosition,
          polylinePointList: Set.of(polylinePointList),
          tfController: tfGisController,
          valveController: valveController,
          serviceController: serviceController,
          regulatorController: regulatorController,
          commercialController: commercialController,
          domesticController: domesticController,
          industrialController: industrialController,
          startAddressController: startAddressController,
          destinationAddressController: destinationAddressController,
          emergencyController: emergencyController,
          listOfTfId: listOfTFId,
          listOfValveId: listOfValveId,
          listOfServiceId: listOfServiceId,
          listOfRegulatorId: listOfRegulatorId,
          listOfCommercialId: listOfCommercialId,
          listOfDomesticId: listOfDomesticId,
          listOfIndustrialId: listOfIndustrialId,
          listOfEmergencyId: listOfEmergencyId,
          curPlaceList: curPlaceList,
          desPlaceList: desPlaceList,
        ),
      );
    });
  }

  _eventCompleted(Emitter<IncidentReportState> emit) {
    emit(
      FetchIncidentReportDataState(
        isLoader: isLoader,
        isRefresh: isRefresh,
        isMapDir: isMapDir,
        isVisible: isVisible,
        isPipelineLoader: isPipelineLoader,
        checkTf: checkTf,
        isTfLoader: isTFLoader,
        checkValve: checkValve,
        checkService: checkService,
        isValveLoader: isValveLoader,
        isServiceLoader: isServiceLoader,
        checkRegulator: checkRegulator,
        isRegulatorLoader: isRegulatorLoader,

        checkCommercial: checkCommercial,
        isCommercialLoader: isCommercialLoader,
        checkDomestic: checkDomestic,
        isDomesticLoader: isDomesticLoader,
        checkIndustrial: checkIndustrial,
        isIndustrialLoader: isIndustrialLoader,

        startAddress: startAddress,
        destinationAddress: destinationAddress,
        placeDistance: placeDistance,
        baseUrl: baseUrl,
        nameofLocation: nameofLocation,
        role: role,
        googleMapController: googleMapController,
        currentMapType: currentMapType,
        markersPointList: Set.of(markersPointList),
        currentPosition: currentPosition,
        polylinePointList: Set.of(polylinePointList),
        tfController: tfGisController,
        valveController: valveController,
        serviceController: serviceController,
        regulatorController: regulatorController,
        commercialController: commercialController,
        domesticController: domesticController,
        industrialController: industrialController,
        startAddressController: startAddressController,
        destinationAddressController: destinationAddressController,
        emergencyController: emergencyController,
        listOfTfId: listOfTFId,
        listOfValveId: listOfValveId,
        listOfServiceId: listOfServiceId,
        listOfRegulatorId: listOfRegulatorId,
        listOfCommercialId: listOfCommercialId,
        listOfDomesticId: listOfDomesticId,
        listOfIndustrialId: listOfIndustrialId,
        listOfEmergencyId: listOfEmergencyId,
        curPlaceList: curPlaceList,
        desPlaceList: desPlaceList,
      ),
    );
  }
}
