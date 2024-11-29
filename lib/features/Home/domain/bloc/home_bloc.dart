import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_event.dart';
import 'package:igl_outage_app/features/Home/domain/bloc/home_state.dart';
import 'package:igl_outage_app/features/Login/domain/model/login_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeLoadEvent>(_pageLoad);
  }

  bool isLoader =  false;
  String scheme = '';
  String role = '';
  String userName = '';
  String baseUrl = '';
  String accessRightData = '';
  List<Accessright> listOFAccessRight = [];

  _pageLoad(HomeLoadEvent event, emit) async {
    emit(HomeInitialState());
    isLoader =  false;
    scheme = await SharedPref.getString(key: PrefsValue.schema);
    role = await SharedPref.getString(key: PrefsValue.userRole);
    userName = await SharedPref.getString(key: PrefsValue.userName);
    baseUrl = await SharedPref.getString(key: PrefsValue.baseUrl);
    var json = await SharedPref.getString(key: PrefsValue.accessRight);
    listOFAccessRight = Accessright.accessrightListFromJson(json);
    listOFAccessRight.sort((a,b) => a.menuCode!.compareTo(b.menuCode!));
    _eventCompleted(emit);
  }
  _eventCompleted(Emitter<HomeState> emit) {
    emit(FetchHomeDataState(
        isLoader: isLoader,
        scheme: scheme,
        baseUrl: baseUrl,
        userName: userName,
        role: role,
      listOFAccessRight: listOFAccessRight,
    ));
  }
}
