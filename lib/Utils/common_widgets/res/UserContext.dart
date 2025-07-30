import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

import 'app_config.dart';

class UserContext {
  final String gaId;
  final String schema;
  final String areas;
  final User user;
  final GridData gridData;
  final bool isHo;

  UserContext({required this.gaId, required this.schema, required this.areas, required this.isHo, required this.user, required this.gridData});
  static UserContext getUserContext() {
    final appConfig = AppConfig.instanceInit();
    final user = appConfig?.loginData.user;
    final gridData = appConfig?.gridData;
    final districtData = appConfig?.districtData;

    final isHo = user?.isHo == "1";

    return UserContext(
      isHo: isHo,
      user: user!,
      gridData: gridData!,
      schema: isHo ? (districtData?.schema ?? "") : (user.schema ?? ""),
      areas: isHo ? (gridData.id ?? "") : (user.areas ?? ""),
      gaId: isHo ? (districtData?.id ?? "") : (user.gaId ?? ""),
    );
  }


}
