import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import '../../../../../Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'maintenance_alert_event.dart';
import 'maintenance_alert_state.dart';

class MaintenanceAlertBloc extends Bloc<MaintenanceAlertEvent, MaintenanceAlertState> {
  MaintenanceAlertBloc() : super(MaintenanceAlertInitialState()) {
    on<MaintenanceAlertLoadEvent>(_pageLoad);
  }

  bool isLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';

  _pageLoad(MaintenanceAlertLoadEvent event, emit) async {
    emit(MaintenanceAlertInitialState());
    isLoader =  false;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<MaintenanceAlertState> emit) {
    emit(FetchMaintenanceAlertDataState(
      isLoader: isLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
    ));
  }
}
