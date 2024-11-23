import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
class WaveLoaderWidget extends StatelessWidget {
  const WaveLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.12;
    return SpinKitFadingCircle(color: AppColor.primer,size: size,);
  }
}
