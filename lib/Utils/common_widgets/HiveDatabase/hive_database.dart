import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:path_provider/path_provider.dart';

import 'hive_box_name.dart';

class HiveDataBase {
  static Box<PipelineData>? pipelineDataBox;


Future<void> init() async {
  Directory tempDir = await getApplicationDocumentsDirectory();
  Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
  await Hive.initFlutter(filesDir.path);
  Hive.registerAdapter(PipelineDataAdapter());

   pipelineDataBox = await Hive.openBox<PipelineData>(HiveBoxName.pipelineDataBox);

}
}