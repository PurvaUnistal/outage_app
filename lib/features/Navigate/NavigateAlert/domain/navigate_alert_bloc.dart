import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'navigate_alert_event.dart';
import 'navigate_alert_state.dart';

class NavigateAlertBloc extends Bloc<NavigateAlertEvent, NavigateAlertState> {
  NavigateAlertBloc() : super(NavigateAlertInitialState()) {
    on<NavigateAlertLoadEvent>(_pageLoad);
    on<SelectMapTypeButtonEvent>(_selectMapTypeButton);
    on<SelectAddMarkerButtonEvent>(_selectAddMarkerButton);
    on<SelectCameraPositionButtonEvent>(_selectCameraPositionButton);
    on<SelectCameraMoveButtonEvent>(_selectCameraMoveButton);
  }

  bool isLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';
  Set<Marker> markers = {};
  MapType currentMapType = MapType.normal;
  Completer<GoogleMapController> controller = Completer();
  static  LatLng center = LatLng(45.521563, -122.677433);
  LatLng lastMapPosition = center;

  _pageLoad(NavigateAlertLoadEvent event, emit) async {
    emit(NavigateAlertInitialState());
    isLoader =  false;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    var json = await SharedPref.getString(key: PrefsValue.accessRight);
    currentMapType = MapType.normal;
    markers = {};
    controller = Completer();
    center = const LatLng(45.521563, -122.677433);
    lastMapPosition = center;
    _eventCompleted(emit);
  }


  _selectMapTypeButton(SelectMapTypeButtonEvent event, emit) {
    currentMapType = currentMapType == MapType.normal
        ? MapType.satellite
        : MapType.normal;
    _eventCompleted(emit);
  }

 _selectAddMarkerButton(SelectAddMarkerButtonEvent event,  emit) {
   markers.add(Marker(
     markerId: MarkerId(lastMapPosition.toString()),
     position: lastMapPosition,
     infoWindow: InfoWindow(
       title: 'Text',
       snippet: 'Text',
     ),
     icon: BitmapDescriptor.defaultMarker,
   ));
  }

  _selectCameraPositionButton(SelectCameraPositionButtonEvent event, emit) {

  }

  _selectCameraMoveButton(SelectCameraMoveButtonEvent event,  emit) {
    lastMapPosition = event.cameraPosition.target;
  }

  _eventCompleted(Emitter<NavigateAlertState> emit) {
    emit(FetchNavigateAlertDataState(
      isLoader: isLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
      currentMapType: currentMapType,
      markers: markers,
    ));
  }

}
