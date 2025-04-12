import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

class WaveLoaderWidget extends StatelessWidget {
  const WaveLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        height: h * 0.15,
        width: w * 0.30,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(
                color: EnvironmentConfig.of(context)!.primaryTheme,
                size: w * 0.12,
              ),
              Text(
                "Loading...",
                style: Styles.labels,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
