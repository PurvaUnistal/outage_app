import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionDialogUtils {
  static SessionDialogUtils _instance = new SessionDialogUtils.internal();

  SessionDialogUtils.internal();

  factory SessionDialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,{required Function okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Timeout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Session was expire you need to login again?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Login'),
                onPressed: okBtnFunction(),
              ),
            ],
          );
        });
  }



  static logOut({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(PrefsValue.isUserLogIn, false);
      prefs.setString(PrefsValue.userName, '');
      prefs.setString(PrefsValue.passwordVal, '');
      prefs.setString(PrefsValue.userId, '');
      prefs.setString(PrefsValue.token, '');
      prefs.setString(PrefsValue.schema, '');
      prefs.setString(PrefsValue.userName, '');
     /* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
            (Route<dynamic> route) => false,
      );*/
    } catch (e) {
      print(e.toString());
    }
  }
}