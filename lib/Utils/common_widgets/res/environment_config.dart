import 'package:flutter/material.dart';

import 'enums.dart';

class EnvironmentConfig extends InheritedWidget {
  final EnvironmentFlavor flavor;

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
      case EnvironmentFlavor.prodAGCL:
        return "http://agcl.smartgasnet.com/api/";
      case EnvironmentFlavor.prodMGL:
        return "https://mgl.smartgasnet.com/api/";
      case EnvironmentFlavor.prodPBGPL:
        return "http://pbgpl.smartgasnet.com/api/";
      case EnvironmentFlavor.prodIGL:
        return "https://igl.smartgasnet.com/api/";
      case EnvironmentFlavor.prodHPOIL:
        return "https://hpoil.smartgasnet.com/api/";
    }
  }

  Color get primaryTheme {
    switch (flavor) {
      case EnvironmentFlavor.prodAGCL:
        return Colors.blue.shade800;
      case EnvironmentFlavor.prodMGL:
        return Colors.green.shade800;
      case EnvironmentFlavor.prodPBGPL:
        return Colors.green.shade800;
      case EnvironmentFlavor.prodIGL:
        return Colors.yellow.shade800;
      case EnvironmentFlavor.prodHPOIL:
        return Colors.red.shade700;
    }
  }

  Color get secondaryTheme {
    switch (flavor) {
      case EnvironmentFlavor.prodAGCL:
        return Colors.blue.shade800;
      case EnvironmentFlavor.prodMGL:
        return Colors.yellow.shade800;
      case EnvironmentFlavor.prodPBGPL:
        return Colors.yellow.shade800;
      case EnvironmentFlavor.prodIGL:
        return Colors.green.shade800;
      case EnvironmentFlavor.prodHPOIL:
        return Colors.green.shade800;
    }
  }
}
