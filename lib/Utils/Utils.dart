import 'package:flutter/material.dart';

import 'common_widgets/res/app_color.dart';


class Utils {

  static Future<void> successSnackBar({ required String msg,  required BuildContext context}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            Icon(Icons.check_circle, color: AppColor.white,size: 36),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        padding: EdgeInsets.all(8),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static Future<void> warningSnackBar({ required String msg,  required BuildContext context}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            Icon(Icons.warning_amber_rounded, color: AppColor.white,size: 36),
          ],
        ),
        backgroundColor: Colors.orangeAccent.shade200,
        padding: EdgeInsets.all(8),
        duration: Duration(seconds: 3),
      ),
    );
  }


  static  Future<void> errorSnackBar({ required String msg,  required BuildContext context}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            IconButton(
                icon: Icon(Icons.clear, color: AppColor.white,size: 36,),
                onPressed: ()=>  ScaffoldMessenger.of(context).hideCurrentSnackBar()
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(8),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
