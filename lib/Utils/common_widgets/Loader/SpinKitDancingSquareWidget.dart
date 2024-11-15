import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
class SpinKitDancingSquareLoader extends StatelessWidget {
  const SpinKitDancingSquareLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitDancingSquare(color: AppColor.primer,);
  }
}
