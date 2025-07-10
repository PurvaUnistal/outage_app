import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/features/InChargeDashboard/Helper/in_charge_dashboard_helper.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_event.dart';
import 'package:outage_app/features/InChargeDashboard/domain/bloc/in_charge_dashboard_state.dart';
import 'package:outage_app/features/InChargeDashboard/domain/model/InChargeDataModel.dart';

class InChargeDashboardBloc extends Bloc<InChargeDashboardEvent, InChargeDashboardState> {
  InChargeDashboardBloc() : super(InChargeDashboardInitialState()) {
    on<InChargeDashboardPageLoadEvent>(_pageLoad);
  }

  bool isPageLoader = false;
  Dashboard dashboard = Dashboard();
  List<ModuleData> listOfInChargeData = [];

  _pageLoad(InChargeDashboardPageLoadEvent event, emit) async {
    emit(InChargeDashboardInitialState());
    isPageLoader = false;
    dashboard = Dashboard();
    listOfInChargeData = [];

    var res = await InChargeDashboardHelper.getInChargeDataApi(context: event.context);
    if (res != null && res.dashboard != null) {
      dashboard = res.dashboard!;
      listOfInChargeData = res.data.where(
              (e) => e.name != "Pipeline GIS"
      ).toList();
    }
    _eventCompleted(emit);
  }


  _eventCompleted(Emitter<InChargeDashboardState> emit) {
    emit(
      FetchInChargeDashboardDataState(
        isPageLoader : isPageLoader,
        dashboard : dashboard,
        listOfInChargeData : listOfInChargeData,
      ),
    );
  }
}
