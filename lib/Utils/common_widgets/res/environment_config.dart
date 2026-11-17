import 'package:flutter/material.dart';

import 'enums.dart';

class EnvironmentConfig extends InheritedWidget {
  final EnvironmentFlavors flavor;

  EnvironmentConfig({required this.flavor, required super.child});

  static EnvironmentConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw true;
  }

  String get generalUrlBaseFlavour {
    print("flavor-->${flavor}");
    switch (flavor) {
      case EnvironmentFlavors.prodAGCL:
        return "http://agcl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodMGL:
        return "https://mgl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodPBGPL:
        return "http://pbgpl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodIGL:
        return "https://igl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodHPOIL:
        return "https://hpoil.smartgasnet.com/api/";
      case EnvironmentFlavors.prodHPCL:
        return "https://hpcl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodHNGPL:
        return "https://hngpl.smartgasnet.com/api/";
      case EnvironmentFlavors.prodCUGL:
        return "https://cugl.smartgasnet.com/api/";
    }
  }

  Color get primaryTheme {
    switch (flavor) {
      case EnvironmentFlavors.prodAGCL:
        return Colors.blue.shade800;
      case EnvironmentFlavors.prodMGL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodPBGPL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodIGL:
        return Colors.yellow.shade800;
      case EnvironmentFlavors.prodHPOIL:
        return Colors.red.shade700;
      case EnvironmentFlavors.prodHPCL:
        return Color(0xFF1A237E);
      case EnvironmentFlavors.prodHNGPL:
        return const Color(0xFF0E6D5A);
      case EnvironmentFlavors.prodCUGL:
        return const Color(0xFFED3237);
    }
  }

  Color get secondaryTheme {
    switch (flavor) {
      case EnvironmentFlavors.prodAGCL:
        return Colors.blue.shade800;
      case EnvironmentFlavors.prodMGL:
        return Colors.yellow.shade800;
      case EnvironmentFlavors.prodPBGPL:
        return Colors.yellow.shade800;
      case EnvironmentFlavors.prodIGL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodHPOIL:
        return Colors.green.shade800;
      case EnvironmentFlavors.prodHPCL:
        return Color(0xFFC62828);
      case EnvironmentFlavors.prodHNGPL:
        return const Color(0xFFF3C111);
      case EnvironmentFlavors.prodCUGL:
        return const Color(0xFF84C44C);
    }
  }
}
