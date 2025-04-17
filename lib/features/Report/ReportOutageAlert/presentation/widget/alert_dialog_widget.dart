import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/features/Report/CreateAlertForm/presentation/create_alert_form_page.dart';

class AlertDialogTwoBtnWidget extends StatelessWidget {
  final BuildContext mContext;

  const AlertDialogTwoBtnWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.002,
            ),
            Text(
              "Do you want to create Report Incident?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: ButtonWidget(
                    text: "No",
                    onPressed: () => Navigator.pop(mContext),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: ButtonWidget(
                    text: "Yes",
                    onPressed: () {
                      Navigator.pushReplacement(mContext, MaterialPageRoute(builder: (BuildContext context) => CreateAlertFormView())
                      );
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
