import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

import 'res/common_style.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const ButtonWidget({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: CommonStyle.gradients,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child:
                Text(text, style: Styles.btnText, textAlign: TextAlign.center)),
      ),
    );
  }
}
