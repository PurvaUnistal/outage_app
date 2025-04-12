import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'maintenance_alert_event.dart';
import 'maintenance_alert_state.dart';

class MaintenanceAlertBloc extends Bloc<MaintenanceAlertEvent, MaintenanceAlertState> {
  MaintenanceAlertBloc() : super(MaintenanceAlertInitialState()) {
    on<MaintenanceAlertLoadEvent>(_pageLoad);
  }

  bool isLoader =  false;
  String role = '';
  String baseUrl = '';

  _pageLoad(MaintenanceAlertLoadEvent event, emit) async {
    emit(MaintenanceAlertInitialState());
    isLoader =  false;
    role = await AppConfig.instanceInit()?.loginData.user?.role! ?? "";
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<MaintenanceAlertState> emit) {
    emit(FetchMaintenanceAlertDataState(
      isLoader: isLoader,
      baseUrl: baseUrl,
      role: role,
    ));
  }
}
