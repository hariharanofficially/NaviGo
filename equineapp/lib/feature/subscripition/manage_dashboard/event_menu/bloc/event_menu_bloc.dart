import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'event_menu_event.dart';
part "event_menu_state.dart";

class EventMenuBloc extends Bloc<EventMenuEvent,EventMenuState>{
  EventMenuBloc(): super(EventMenuInitial()){
    on<EventMenuEvent>((event, emit) {
    emit(EventMenuInitial());
    if (event is SelectTabEventMenu) {
      emit(EventMenuSelectedTab(event.tabindex));
    }
    });
  }
}