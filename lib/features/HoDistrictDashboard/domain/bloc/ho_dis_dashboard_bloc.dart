import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/features/HoDistrictDashboard/domain/model/DistrictDataModel.dart';
import 'package:outage_app/features/HoDistrictDashboard/helper/ho_dis_dashboard_helper.dart';
import 'ho_dis_dashboard_event.dart';
import 'ho_dis_dashboard_state.dart';

class HoDistrictDashboardBloc
    extends Bloc<HoDistrictDashboardEvent, HoDistrictDashboardState> {
  HoDistrictDashboardBloc() : super(HoDistrictDashboardInitialState()) {
    on<HoDistrictDashboardPageLoadEvent>(_pageLoad);
  }

  bool isPageLoader = false;
  Dashboard dashboard = Dashboard();
  List<DistrictData> listOfDistrictData = [];

  _pageLoad(HoDistrictDashboardPageLoadEvent event, emit) async {
    emit(HoDistrictDashboardInitialState());
    isPageLoader = false;
    dashboard = Dashboard();
    listOfDistrictData = [];

    var res = await HoDistrictDashboardHelper.getDistrictDataApi(context: event.context);
    if (res != null && res.dashboard != null && res.data != null) {
      dashboard = res.dashboard!;
      listOfDistrictData = res.data!;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<HoDistrictDashboardState> emit) {
    emit(
      FetchHoDistrictDashboardDataState(
        isPageLoader: isPageLoader,
        dashboard: dashboard,
        listOfDistrictData: listOfDistrictData,
      ),
    );
  }
}
