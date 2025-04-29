import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ConsumerGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/ValveGISModel.dart';
import 'package:path_provider/path_provider.dart';

import 'hive_box_name.dart';

class HiveDataBase {
  static Box<PipelineData>? pipelineDataBox;
  static Box<TFGISData>? tfGISBox;
  static Box<ValveGISData>? valveGISBox;
  static Box<RegulatorGISData>? regulatorGISBox;
  static Box<ConsumerGISData>? consumerGISBox;


Future<void> init() async {
  Directory tempDir = await getApplicationDocumentsDirectory();
  Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
  await Hive.initFlutter(filesDir.path);
  Hive.registerAdapter(PipelineDataAdapter());
  Hive.registerAdapter(TFGISDataAdapter());
  Hive.registerAdapter(ValveGISDataAdapter());
  Hive.registerAdapter(RegulatorGISDataAdapter());
  Hive.registerAdapter(ConsumerGISDataAdapter());

   pipelineDataBox = await Hive.openBox<PipelineData>(HiveBoxName.pipelineDataBox);
  tfGISBox = await Hive.openBox<TFGISData>(HiveBoxName.tfGISBox);
  valveGISBox = await Hive.openBox<ValveGISData>(HiveBoxName.valveGISBox);
  regulatorGISBox = await Hive.openBox<RegulatorGISData>(HiveBoxName.regulatorGISBox);
  consumerGISBox = await Hive.openBox<ConsumerGISData>(HiveBoxName.consumerGISBox);

}
}