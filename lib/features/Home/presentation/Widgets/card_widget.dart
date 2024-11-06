
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final String path;

  const CardWidget({super.key, required this.text, required this.path});

  @override
  Widget build(BuildContext context) {
    return 
    /*  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image:AssetImage(path,), fit: BoxFit.fill,
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(12),
      child: */
      
      Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Image.asset(path,width: 100, height: 100, fit: BoxFit.fill,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(text,
                 style: Styles.count, textAlign: TextAlign.right,
               ),
            ),
          ],
        ),
      );
  }
}
