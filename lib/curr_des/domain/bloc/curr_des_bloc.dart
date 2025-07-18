import 'package:flutter_bloc/flutter_bloc.dart';

import 'curr_des_event.dart';
import 'curr_des_state.dart';

class CurrDesBloc
    extends Bloc<CurrDesEvent, CurrDesState> {
  CurrDesBloc() : super(CurrDesInitialState()) {
    on<CurrDesPageLoadEvent>(_pageLoad);
  }

  bool isPageLoader = false;


  _pageLoad(CurrDesPageLoadEvent event, emit) async {
    emit(CurrDesInitialState());
    isPageLoader = false;

    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<CurrDesState> emit) {
    emit(
      FetchCurrDesDataState(
        isPageLoader: isPageLoader,

      ),
    );
  }
}
