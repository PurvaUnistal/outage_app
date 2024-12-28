import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Configuration class for GIS mapping
class GisConfig {
  final String assetPath;
  final Color polylineColor;
  final Set<Marker> markerList;
  final Set<Polyline>? polylineList;

  GisConfig({
    required this.assetPath,
    required this.polylineColor,
    required this.markerList,
     this.polylineList,
  });
}

class GetPoints{

}

