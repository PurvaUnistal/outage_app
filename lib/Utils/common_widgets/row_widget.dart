import 'package:flutter/material.dart';
import 'package:outage_app/Utils/commonClass/common_style.dart';

class RowWidget extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  const RowWidget({super.key, required this.widget1, required this.widget2,});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: widget1),
        CommonStyle.widthSpace(context: context),
        Flexible(child: widget2),
      ],
    );
  }
}
