import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/roles.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';
import 'Event_oraganizer_event.dart';
import 'event_oraganizer_state.dart';

class EventsOrganizerBloc
    extends Bloc<EventsOrganizerEvent, EventsOrganizerState> {
  EventsOrganizerBloc() : super(EventsOrganizerInitial()) {
    on<EventsOrganizerLoadInitialDataEvent>((event, emit) async {
      emit(EventOrganizerLoading());
      try {
        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final horses = await horseRepo.getAllHorses(tenantId: tenantId);
        final stables = await stablerepo.getAllStable(tenantId);
        final event = await eventrepo.getAllEvent(tenantId: tenantId);
        final List<EventModel> events =
            await eventrepo.getAllEvent(tenantId: tenantId);
        //final RolesModel role = await rolesrepo.getRolesByUserAndTenant();
        final RolesModel role = new RolesModel(id: 1, name: "test", level: 1);
        //   final riders = [
        //  "Antico Oriente","Antico Oriente","Antico Oriente"
        //   ];
        emit(EventsOrganizerInitLoaded(
          events: events,
          role: role,
          stableCount: stables.length,
          horseCount: horses.length,
          eventCount: event.length,
        ));
      } catch (e) {
        emit(EventsOrganizerInitLoadedFailed("Failed to load riders"));
      }
    });
  }
}
