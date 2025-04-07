import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/features/ReportOutage/CreateAlertForm/presentation/create_alert_form_page.dart';

class AlertDialogTwoBtnWidget extends StatelessWidget {
  final BuildContext mContext;

  const AlertDialogTwoBtnWidget({super.key, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Do you want to create Report Incident?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 12,
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
                    /*Navigator.pop(mContext);
                    Navigator.push(
                      mContext,
                      MaterialPageRoute(
                          builder: (buildContext) =>
                              const CreateAlertFormView()),*/
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
