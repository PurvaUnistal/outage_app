import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class CommonStyle {

  static OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
        color: AppColor.primer, style: BorderStyle.solid, width: 0.80),
  );

  static OutlineInputBorder borderGrey = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
        color: AppColor.grey, style: BorderStyle.solid, width: 0.80),
  );

  static OutlineInputBorder borderRed = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
        color: AppColor.red, style: BorderStyle.solid, width: 0.80),
  );

  static Widget vertical({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.016,
    );
  }

  static Widget widthSpace({required BuildContext context}) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.016,
    );
  }

  static Widget col({required Widget child, required BuildContext context}) {
    return Column(
      children: [
        CommonStyle.vertical(context: context),
        child,
      ],
    );
  }

  /////////////////////////Data Table

  static DataColumn dataColumn({required String label}) {
    return DataColumn(
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            label,
            style: Styles.table,
            textAlign: TextAlign.center,
          ),
        ));
  }

  static DataCell dataCell({required String label}) {
    return DataCell(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    ));
  }

  static DataCell dataCellG({required String label}) {
    return DataCell(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(label, style: Styles.title,),
    ));
  }
  static DataCell dataCellY({required String label}) {
    return DataCell(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(label, style: Styles.rowY12,),
    ));
  }
  static DataCell dataCellR({required String label}) {
    return DataCell(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(label, style: Styles.rowR12,),
    ));
  }
}
