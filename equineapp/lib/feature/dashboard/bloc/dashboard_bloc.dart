
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/event_model.dart';
import '../../../data/repo/repo.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitialState()) {
    on<DashboardInitialEvent>((event, emit) async {
      emit(DashboardEventsLoadingState());
      try {
        final events = await trackerRepo.getAllEvents();
        if (events.isEmpty) {
          emit(DashboardEventsEmptyState());
        } else {
          emit(DashboardEventsLoadedState(events: events));
        }
      } catch (e) {
        emit(DashboardEventsErrorState(message: e.toString()));
      }
    });
  }
}
