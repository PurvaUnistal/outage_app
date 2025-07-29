import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/HoGridDashboard/domain/model/GridDataModel.dart';
import 'package:outage_app/features/HoGridDashboard/helper/ho_grid_dashboard_helper.dart';
import 'ho_grid_dashboard_event.dart';
import 'ho_grid_dashboard_state.dart';

class HoGridDashboardBloc extends Bloc<HoGridDashboardEvent, HoGridDashboardState> {
  HoGridDashboardBloc() : super(HoGridDashboardInitialState()) {
    on<HoGridDashboardPageLoadEvent>(_pageLoad);
  }

  bool isPageLoader = false;
  GDashboard dashboard = GDashboard();
  List<GridData> listOfGridData = [];


  _pageLoad(HoGridDashboardPageLoadEvent event, emit) async {
    emit(HoGridDashboardInitialState());
    isPageLoader = false;
    dashboard = GDashboard();
    listOfGridData = [];
    await AppConfig.instanceInit()?.setGridData(
      gridData: GridData(),
    );
    var res = await HoGridDashboardHelper.getGridDataApi(context: event.context);
    if(res != null && res.dashboard != null && res.data != null){
      dashboard = res.dashboard!;
      listOfGridData =res.data!;
    }
    _eventCompleted(emit);
  }


  _eventCompleted(Emitter<HoGridDashboardState> emit) {
    emit(
      FetchHoGridDashboardDataState(
        isPageLoader : isPageLoader,
        dashboard : dashboard,
        listOfGridData : listOfGridData,

      ),
    );
  }
}
