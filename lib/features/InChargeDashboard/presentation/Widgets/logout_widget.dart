import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_box_name.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';
import 'package:outage_app/features/Login/presentation/page/login_page.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.4,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppString.logout + "?",
                  style: Styles.stars,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  AppString.logoutMsg,
                  textAlign: TextAlign.center,
                  style: Styles.title,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  children: [
                    Flexible(
                      child: ButtonWidget(
                          text: AppString.logout,
                          onPressed: () async {
                            await clearAndClosePipelineBox();
                            await SharedPref.clearAll();
                            await  AppConfig.instanceInit()!.setLoginData(newLoginData: LoginModel());
                            await  AppConfig.instanceInit()!.setDistrictData(districtData: DistrictData());
                            await  AppConfig.instanceInit()!.setGridData(gridData: GridData());
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);

                          }),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Flexible(
                       child: ButtonWidget(
                          text: AppString.no,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                     ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> clearAndClosePipelineBox() async {
    final boxes = [
      HiveDataBase.pipelineDataBox,
      HiveDataBase.tfGISBox,
      HiveDataBase.valveGISBox,
      HiveDataBase.regulatorGISBox,
      HiveDataBase.commercialDataBox,
      HiveDataBase.domesticDataBox,
      HiveDataBase.industrialDataBox,

    ];

    final pipelineBox = boxes.first;
    if (pipelineBox != null && pipelineBox.isOpen) {
      for (final box in boxes) {
        if (box?.isOpen ?? false) {
          await box!.clear();
        }
      }
    }
  }

}
