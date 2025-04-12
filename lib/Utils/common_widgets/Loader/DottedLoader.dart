import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

class DottedLoaderWidget extends StatelessWidget {
  const DottedLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.12;
    return SpinKitThreeInOut(
      color: EnvironmentConfig.of(context)!.primaryTheme,
      size: size,
    );
  }
}
