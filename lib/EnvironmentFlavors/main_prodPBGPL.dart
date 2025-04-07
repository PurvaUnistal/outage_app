import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/commonClass/enums.dart';
import 'package:outage_app/Utils/commonClass/environment_config.dart';
import 'package:outage_app/features/ReportOutage/ReportOutageAlert/helper/report_alert_helper.dart';
import 'package:outage_app/root.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
  await ReportAlertHelper.clearCache();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  var environmentConfig = EnvironmentConfig(
      flavor: EnvironmentFlavor.prodPBGPL,
      child: RootApp(
        client: Client.purvaBharti,
      ));
  runApp(environmentConfig);
}
