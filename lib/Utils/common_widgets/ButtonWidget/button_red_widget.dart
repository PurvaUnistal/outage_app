import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class ButtonRedWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const ButtonRedWidget({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.red,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: AppColor.red, style: BorderStyle.solid, width: 0.80),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text, style: Styles.btnText,textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
