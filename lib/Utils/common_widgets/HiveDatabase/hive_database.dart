import 'package:hive_flutter/hive_flutter.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/CommercialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/DomesticModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/IndustrialModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/PipelineModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/RegulatorGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/ServiceModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/TFGISModel.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/model/ValveGISModel.dart';
import 'hive_box_name.dart';

class HiveDataBase {
  static Box<PipelineData>? pipelineDataBox;
  static Box<TFGISData>? tfGISBox;
  static Box<ValveGISData>? valveGISBox;
  static Box<ServiceData>? serviceGISBox;
  static Box<RegulatorGISData>? regulatorGISBox;
  static Box<CommercialData>? commercialDataBox;
  static Box<DomesticData>? domesticDataBox;
  static Box<IndustrialData>? industrialDataBox;

  static List<Box?> get _allBoxes => [
    pipelineDataBox,
    tfGISBox,
    valveGISBox,
    serviceGISBox,
    regulatorGISBox,
    commercialDataBox,
    domesticDataBox,
    industrialDataBox,
  ];

  Future<void> init() async {
    await Hive.initFlutter();

    _register(PipelineDataAdapter());
    _register(TFGISDataAdapter());
    _register(ValveGISDataAdapter());
    _register(ServiceDataAdapter());
    _register(RegulatorGISDataAdapter());
    _register(CommercialDataAdapter());
    _register(DomesticDataAdapter());
    _register(IndustrialDataAdapter());

    pipelineDataBox = await Hive.openBox<PipelineData>(HiveBoxName.pipelineDataBox);
    tfGISBox = await Hive.openBox<TFGISData>(HiveBoxName.tfGISBox);
    valveGISBox = await Hive.openBox<ValveGISData>(HiveBoxName.valveGISBox);
    serviceGISBox = await Hive.openBox<ServiceData>(HiveBoxName.serviceGISBox);
    regulatorGISBox = await Hive.openBox<RegulatorGISData>(HiveBoxName.regulatorGISBox);
    commercialDataBox = await Hive.openBox<CommercialData>(HiveBoxName.commercialDataBox);
    domesticDataBox = await Hive.openBox<DomesticData>(HiveBoxName.domesticDataBox);
    industrialDataBox = await Hive.openBox<IndustrialData>(HiveBoxName.industrialDataBox);
  }

  static void _register<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  /// Empties every open box. Boxes stay open so they can be reused after re-login.
  static Future<void> clearAllHiveData() async {
    await Future.wait(
      _allBoxes
          .where((box) => box != null && box.isOpen)
          .map((box) => box!.clear().catchError((_) => 0)),
    );
  }
}