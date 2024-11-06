import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';

class Styles {
  static TextStyle rel = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 8,decoration: TextDecoration.none);
  static TextStyle relB = TextStyle(color: AppColor.black, fontWeight: FontWeight.w800, fontSize: 8);
  static TextStyle appTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12);
  static TextStyle btnText = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,);
  static TextStyle text = TextStyle(fontSize: 12, color: AppColor.primer, fontWeight: FontWeight.bold);
  static TextStyle subTitle = const TextStyle(fontSize: 8, fontWeight: FontWeight.w800);
  static TextStyle subStar = const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.red);
  static TextStyle stars = const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red);
  static TextStyle table = const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
  static TextStyle labels = TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: AppColor.primer);
  static TextStyle labelsW = TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: AppColor.white);
  static TextStyle labelGrey = TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: AppColor.black54);
  static TextStyle title = TextStyle(fontSize: 12, color: Colors.green.shade800, fontWeight: FontWeight.bold);
  static TextStyle rowR12 = TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold);
  static TextStyle rowY12 = TextStyle(fontSize: 12, color: AppColor.primer1, fontWeight: FontWeight.bold);
  static TextStyle count = const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black);
  static TextStyle countW = const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
  static TextStyle texts = const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
}
