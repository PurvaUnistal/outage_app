import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:path_provider/path_provider.dart';
import 'hive_box_name.dart';

class HiveDataBase {
  static Box<TfGisData>? allGisDataBox;
  Future<void> init() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
    Hive.init(filesDir.path);

    Hive.registerAdapter(TfGisDataAdapter());

    allGisDataBox = await Hive.openBox<TfGisData>(HiveBoxName.allGisDataBox);
  }
}
