class HiveBoxName {
  static get pipelineDataBox => "pipelineDataBox";
  static get tfGISBox => "tfGISBox";
  static get valveGISBox => "valveGISBox";
  static get regulatorGISBox => "regulatorGISBox";
  static get consumerGISBox => "consumerGISBox";
}

class HiveTypeId {
  static const pipelineData = 0;
  static const tfGis = 1;
  static const valveGis = 2;
  static const regulatorGis = 3;
  static const consumerGis = 4;
}
