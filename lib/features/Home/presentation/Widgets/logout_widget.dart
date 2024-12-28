import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/features/Login/presentation/page/login_page.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.9,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
      child: SingleChildScrollView(
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
            Column(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonWidget(
                    text: AppString.logout,
                    onPressed: () async {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                      await SharedPref.clearAll();
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ButtonWidget(
                    text: AppString.no,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
