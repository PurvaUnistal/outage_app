import 'package:flutter/material.dart';

import 'res/app_color.dart';

class IconButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  const IconButtonWidget({super.key, required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(iconData, color: AppColor.primer, size: 15,),
    ));
  }
}
