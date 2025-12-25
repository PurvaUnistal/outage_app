import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/incident_report_helper.dart';
import 'package:outage_app/root.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
  await IncidentReportHelper.clearCache();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  var environmentConfig = EnvironmentConfig(
      flavor: EnvironmentFlavor.prodMGL,
      child: RootApp(
        client: Client.mahaNagar,
      ));
  runApp(environmentConfig);
}
