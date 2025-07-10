class InChargeDataModel {
  final int? success;
  final bool? error;
  final Dashboard? dashboard;
  final List<ModuleData> data;

  InChargeDataModel({
    this.success,
    this.error,
    this.dashboard,
    this.data = const [],
  });

  factory InChargeDataModel.fromJson(Map<String, dynamic> json) {
    return InChargeDataModel(
      success: json['success'],
      error: json['error'],
      dashboard: json['dashboard'] != null
          ? Dashboard.fromJson(json['dashboard'])
          : null,
      data: (json['data'] is List)
          ? (json['data'] as List)
          .map((e) => ModuleData.fromJson(e))
          .toList()
          : [],
    );
  }
}

class Dashboard {
  final String? mdpeLength;
  final String? steelLength;
  final int? domesticCount;
  final int? industrialCommercialCount;
  final int? totalPendingIncident;
  final int? totalInprogressIncident;
  final int? totalCompletedIncident;

  Dashboard({
    this.mdpeLength,
    this.steelLength,
    this.domesticCount,
    this.industrialCommercialCount,
    this.totalPendingIncident,
    this.totalInprogressIncident,
    this.totalCompletedIncident,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      mdpeLength: json['mdpe_length'],
      steelLength: json['steel_length'],
      domesticCount: json['domestic_count'],
      industrialCommercialCount: json['industrial_commercial_count'],
      totalPendingIncident: json['total_pending_incident'],
      totalInprogressIncident: json['total_inprogress_incident'],
      totalCompletedIncident: json['total_completed_incident'],
    );
  }
}

class ModuleData {
  final String? menuCode;
  final String? id;
  final String? name;
  final String? submoduleAlias;
  final String? manage;
  final String? add;
  final String? navigate;

  ModuleData({
    this.menuCode,
    this.id,
    this.name,
    this.submoduleAlias,
    this.manage,
    this.add,
    this.navigate,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) {
    return ModuleData(
      menuCode: json['menu_code'],
      id: json['id'],
      name: json['name'],
      submoduleAlias: json['submodule_alias'],
      manage: json['manage'],
      add: json['add'],
      navigate: json['navigate'],
    );
  }
}
