import 'package:flutter/material.dart';

import 'res/app_color.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const IconButtonWidget(
      {Key? key, required this.iconData, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: AppColor.primer,
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconData,
              size: 23.0,
              color: AppColor.white,
            )));
  }
}
