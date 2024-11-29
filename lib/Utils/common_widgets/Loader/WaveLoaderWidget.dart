import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class WaveLoaderWidget extends StatelessWidget {
  const WaveLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print("w-->${w * 0.30}");
    print("h-->${h * 0.15}");
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
                color: AppColor.primer,
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
