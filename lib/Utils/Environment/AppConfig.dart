import 'package:flutter/material.dart';

enum EnvironmentFlavours{ dev, prod,}

class AppConfig extends InheritedWidget{
  final String appName;
  final String flavorName;
  final String baseURL;


 const AppConfig({
    required this.appName,
    required this.flavorName,
    required this.baseURL,
    required Widget child,
  }) : super(child: child);

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  String? get getBaseUrl{
    switch(flavorName){
      case EnvironmentFlavours.dev :
    //    return Apis.baseUatUrl;
        return "Apis.baseUatUrl";
      case EnvironmentFlavours.prod :
        return "Apis.baseLiveUrl";
    }
    return null;
  }
}

