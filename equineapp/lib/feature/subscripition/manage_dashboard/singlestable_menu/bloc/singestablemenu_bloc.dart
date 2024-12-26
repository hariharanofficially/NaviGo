import 'package:EquineApp/feature/subscripition/manage_dashboard/singlestable_menu/bloc/singlestablemenu_event.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/singlestable_menu/bloc/singlestablemenu_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC
class SingleStableMenuBloc extends Bloc<SingleStableMenuEvent, SingleStableMenuState> {
  SingleStableMenuBloc() : super(SingleStableMenuInitial()){
    on<SingleStableMenuEvent>((event, emit) async {
    emit(SingleStableMenuInitial());
    if (event is SelectTabEvent) {
      emit (SingleStableMenuSelectedTab(event.tabIndex));
    }
  });
  }
  // @override
  // Stream<SingleStableMenuState> mapEventToState(SingleStableMenuEvent event) async* {
  //   if (event is SelectTabEvent) {
  //     yield SingleStableMenuSelectedTab(event.tabIndex);
  //   }
  // }
}