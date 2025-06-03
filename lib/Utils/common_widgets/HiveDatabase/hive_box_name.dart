class HiveBoxName {
  static get pipelineDataBox => "pipelineDataBox";
  static get tfGISBox => "tfGISBox";
  static get valveGISBox => "valveGISBox";
  static get regulatorGISBox => "regulatorGISBox";
  static get commercialDataBox => "commercialDataBox";
  static get domesticDataBox => "domesticDataBox";
  static get industrialDataBox => "industrialDataBox";
}

class HiveTypeId {
  static const pipelineData = 0;
  static const tfGis = 1;
  static const valveGis = 2;
  static const regulatorGis = 3;
  static const commercial = 4;
  static const domestic = 5;
  static const industrial = 6;
}
