import 'dart:async';

import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/bloc/single_stable_event.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/bloc/single_stable_state.dart';
import 'package:bloc/bloc.dart';

import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/roles.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';

class SingleStableDashboardBloc
    extends Bloc<SingleStableDashboardEvent, SingleStableDashboardState> {
  SingleStableDashboardBloc() : super(SingleStableDashboardInitial()) {
    on<SingleStableLoadInitialDataEvent>((event, emit) async {
      emit(SingleStableLoading());
      try {
        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final riders = await riderrepo.getAllRider();
        final horses = await horseRepo.getAllHorses(tenantId: tenantId);
        final stables = await stablerepo.getAllStable(tenantId);
        final List<EventModel> events =
            await eventrepo.getAllEvent(tenantId: tenantId);
        //final RolesModel role = await rolesrepo.getRolesByUserAndTenant();
        final RolesModel role =
            new RolesModel(id: 1, name: "trainer", level: 1);
        //   final riders = [
        //  "Antico Oriente","Antico Oriente","Antico Oriente"
        //   ];
        emit(SingleStableInitLoaded(
            riderCount: riders.length,
            horseCount: horses.length,
            stableCount: stables.length,
            events: events,
            role: role));
      } catch (e) {
        emit(SingleStableInitLoadedFailed("Failed to load riders"));
      }
    });
  }
}
