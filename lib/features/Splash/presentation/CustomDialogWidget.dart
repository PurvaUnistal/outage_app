import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeDialog extends StatelessWidget {
 final BuildContext mContext;
 final String appStoreUrl;
  const UpgradeDialog({super.key, required this.mContext, required this.appStoreUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Required"),
      content: Text(
        "A new version of the app is available. Please update to continue.",
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (await canLaunch(appStoreUrl)) {
              await launch(appStoreUrl);
            } else {
              throw "Could not launch $appStoreUrl";
            }
          },
          child: Text("Update Now"),
        ),
      ],
    );
  }
}



class ForceUpgradeDialog{

  static Future<String> getCurrentAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static bool isUpdateRequired({required String currentVersion,required String latestVersion}) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latest.length; i++) {
      if (i >= current.length || current[i] < latest[i]) return true;
      if (current[i] > latest[i]) return false;
    }
    return false;
  }

  static showForceUpgradeDialog({required BuildContext context,required String appStoreUrl}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal
      builder: (context) {
        return AlertDialog(
          title: Text("Update Required"),
          content: Text(
            "A new version of the app is available. Please update to continue.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await canLaunch(appStoreUrl)) {
                  await launch(appStoreUrl);
                } else {
                  throw "Could not launch $appStoreUrl";
                }
              },
              child: Text("Update Now"),
            ),
          ],
        );
      },
    );
  }

}

