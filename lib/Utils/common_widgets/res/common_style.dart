import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';

import 'environment_config.dart';
import 'singleton.dart';

class CommonStyle {
  static BuildContext? context = Singleton.instanceInit()?.context;

  static LinearGradient gradients = LinearGradient(
    colors: [
      EnvironmentConfig.of(context!)!.secondaryTheme,
      EnvironmentConfig.of(context!)!.primaryTheme,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
        color: EnvironmentConfig.of(context!)!.primaryTheme, style: BorderStyle.solid, width: 0.80),
  );

  static OutlineInputBorder borderGrey = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide:
        BorderSide(color: AppColor.grey, style: BorderStyle.solid, width: 0.80),
  );

  static OutlineInputBorder borderRed = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide:
        BorderSide(color: AppColor.red, style: BorderStyle.solid, width: 0.80),
  );

  static Widget vertical({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.009,
    );
  }

  static Widget widthSpace({required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.016,
    );
  }

}
