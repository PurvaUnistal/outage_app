import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GisConfig {
  final Set<Marker> markerList;
  final Set<Polyline>? polylineList;
  final dynamic detailsData;

  GisConfig({
    required this.markerList,
    required this.detailsData,
     this.polylineList,
  });
}

