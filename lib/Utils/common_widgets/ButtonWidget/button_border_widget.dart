import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class ButtonBorderWidget extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color color;
  const ButtonBorderWidget({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0) //
              ),
              border: Border.all(color: color, width: 1)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(text,style: Styles.titleBlack(color: color)),
          )),
    );
  }
}


class ButtonColorWidget extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color color;
  const ButtonColorWidget({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0) //
              ),
              border: Border.all(color: color, width: 1)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(text,style: Styles.titleBoldWhite),
          )),
    );
  }
}