import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const ButtonWidget({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  width: MediaQuery.of(context).size.width  / 0.2,
    //  margin: EdgeInsets.symmetric(horizontal: 80),
      child: ElevatedButton(
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(AppColor.primer),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            ),
           ),
       child:  Text(text, style: Styles.btnText,textAlign: TextAlign.center),
        onPressed: onPressed,
      ),
    );
  }
}
