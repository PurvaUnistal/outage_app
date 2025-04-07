import 'package:flutter/material.dart';
import 'package:outage_app/Utils/commonClass/environment_config.dart';

import 'res/app_color.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  const IconButtonWidget(
      {Key? key, required this.iconData, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: EnvironmentConfig.of(context!)!.primaryTheme,
        ));
  }
}
