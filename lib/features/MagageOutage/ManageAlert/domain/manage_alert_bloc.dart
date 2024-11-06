import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';

import 'manage_alert_event.dart';
import 'manage_alert_state.dart';

class ManageAlertBloc extends Bloc<ManageAlertEvent, ManageAlertState> {
  ManageAlertBloc() : super(ManageAlertInitialState()) {
    on<ManageAlertLoadEvent>(_pageLoad);
  }

  bool isLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';

  _pageLoad(ManageAlertLoadEvent event, emit) async {
    emit(ManageAlertInitialState());
    isLoader =  false;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    var json = await SharedPref.getString(key: PrefsValue.accessRight);

    _eventCompleted(emit);
  }
  _eventCompleted(Emitter<ManageAlertState> emit) {
    emit(FetchManageAlertDataState(
      isLoader: isLoader,
      scheme: scheme,
      baseUrl: baseUrl,
      userName: userName,
      role: role,
    ));
  }
}
