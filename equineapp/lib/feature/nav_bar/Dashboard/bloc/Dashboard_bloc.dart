// dashboard_bloc.dart
import 'package:EquineApp/feature/nav_bar/Dashboard/bloc/Dashboard_event.dart';
import 'package:EquineApp/feature/nav_bar/Dashboard/bloc/Dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardEvent>((event, emit) {
      emit(DashboardLoaded());
    });

    on<NavigateToAddStableEvent>((event, emit) {
      emit(NavigateToStable());
    });

    on<NavigateToAddHorseEvent>((event, emit) {
      emit(NavigateToHorse());
    });

    on<NavigateToAddRiderEvent>((event, emit) {
      emit(NavigateToRider());
    });

    on<NavigateToPlanEvent>((event, emit) {
      emit(NavigateToPlan(event.screen));
    });
  }
}
