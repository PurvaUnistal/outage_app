import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/IndustrialModel.dart';
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
  static Box<CommercialData>? commercialDataBox;
  static Box<DomesticData>? domesticDataBox;
  static Box<IndustrialData>? industrialDataBox;


Future<void> init() async {
  Directory tempDir = await getApplicationDocumentsDirectory();
  Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
  await Hive.initFlutter(filesDir.path);
  Hive.registerAdapter(PipelineDataAdapter());
  Hive.registerAdapter(TFGISDataAdapter());
  Hive.registerAdapter(ValveGISDataAdapter());
  Hive.registerAdapter(RegulatorGISDataAdapter());
  Hive.registerAdapter(CommercialDataAdapter());
  Hive.registerAdapter(DomesticDataAdapter());
  Hive.registerAdapter(IndustrialDataAdapter());

   pipelineDataBox = await Hive.openBox<PipelineData>(HiveBoxName.pipelineDataBox);
  tfGISBox = await Hive.openBox<TFGISData>(HiveBoxName.tfGISBox);
  valveGISBox = await Hive.openBox<ValveGISData>(HiveBoxName.valveGISBox);
  regulatorGISBox = await Hive.openBox<RegulatorGISData>(HiveBoxName.regulatorGISBox);
  commercialDataBox = await Hive.openBox<CommercialData>(HiveBoxName.commercialDataBox);
  domesticDataBox = await Hive.openBox<DomesticData>(HiveBoxName.domesticDataBox);
  industrialDataBox = await Hive.openBox<IndustrialData>(HiveBoxName.industrialDataBox);

}
}