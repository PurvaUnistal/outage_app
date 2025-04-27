import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GisConfig {
  final String assetPath;
  final Set<Marker> markerList;
  final Set<Polyline>? polylineList;

  GisConfig({
    required this.assetPath,
    required this.markerList,
     this.polylineList,
  });
}

