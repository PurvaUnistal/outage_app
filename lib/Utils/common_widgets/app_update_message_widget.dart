import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'res/app_styles.dart';

class AppUpdateMessage {
  static showAlertDialog(
      {required BuildContext context, required String url, bool? isLater}) {
    Widget cancelButton = TextButton(
      child: isLater == null
          ? Text(
        "Update Later",
        style: Styles.title,
      )
          : isLater == true
          ? const SizedBox.shrink()
          : Text(
        "Update Later",
        style: Styles.title,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Update Now",
        style: Styles.title,
      ),
      onPressed: () async {
        if (!await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch ');
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Builder(builder: (context) {
        return Text(
          "Update Available",
          style: Styles.stars,
        );
      }),
      content: Text(
        "Please update the app to continue",
        style: Styles.labels,
      ),
      actions: [
        //   cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => _onWillPop(),
            child: alert);
      },
    );
  }
  static Future<bool> _onWillPop() async {
    return false;
  }
}
