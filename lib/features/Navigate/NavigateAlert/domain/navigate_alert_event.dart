import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class NavigateAlertEvent extends Equatable{}

class NavigateAlertLoadEvent extends NavigateAlertEvent {
  final BuildContext context;
  NavigateAlertLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class SelectMapTypeButtonEvent extends NavigateAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectAddMarkerButtonEvent extends NavigateAlertEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SelectCameraMoveButtonEvent extends NavigateAlertEvent {
 final CameraPosition cameraPosition;
 SelectCameraMoveButtonEvent({required this.cameraPosition});
  @override
  // TODO: implement props
  List<Object> get props => [cameraPosition];
}
class SelectCameraPositionButtonEvent extends NavigateAlertEvent {
 final CameraPosition cameraPosition;
 SelectCameraPositionButtonEvent({required this.cameraPosition});
  @override
  // TODO: implement props
  List<Object> get props => [cameraPosition];
}
