import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Report/ReportOutage/helper/incident_report_helper.dart';
import 'package:outage_app/root.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDataBase().init();
  await Firebase.initializeApp();
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  var appDir = (await getTemporaryDirectory()).path;
  new Directory(appDir).delete(recursive: true);
  await IncidentReportHelper.clearCache();
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  ]);

  var environmentConfig = EnvironmentConfig(flavor: EnvironmentFlavor.prodAGCL, child: RootApp(
    client: Client.agcl,
  ));
  runApp(environmentConfig);
}