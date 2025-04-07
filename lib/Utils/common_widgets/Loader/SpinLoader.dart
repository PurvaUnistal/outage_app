import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outage_app/Utils/commonClass/environment_config.dart';


class SpinLoader extends StatelessWidget {
  const SpinLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCubeGrid(color: EnvironmentConfig.of(context)!.primaryTheme,);
  }
}
