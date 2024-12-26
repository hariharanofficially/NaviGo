import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import '../../../data/models/event_model.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';

part 'bysession_event.dart';
part 'bysession_state.dart';

// Bloc class
class Bysessionbloc extends Bloc<Bysessionevent, Bysessionstate> {
  Logger logger = new Logger();

  Bysessionbloc() : super(BysessionLoading()) {
    // Load initial sessions
    on<LoadSessionsEvent>((event, emit) async {
      try {
        var tenantId = await cacheService.getString(name: 'tenantId');

        final Sessions = await eventrepo.getAllEvent(tenantId: tenantId);
        List<EventModel> event = [];
        Sessions.forEach((e) => {
              if (e.raceType == "training") {event.add(e)}
            });
        logger.d(event);
        logger.d(event);
        // final Sessions = [
        //   "Antico Oriente",
        //   "Antico Oriente",
        //   "Antico Oriente",
        // ]; // Replace with actual data fetching logic

        emit(BysessionLoaded(sessions: event));
      } catch (e) {
        emit(Bysessionerror("Failed to load horses"));
      }
    });

    on<Traningcreated>((event, emit) async {
      emit(TraningSubmitting());
      try {
        final response = await eventrepo.addtraning();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(TraningSubmittedSuccessfully(message: response.message));
        } else {
          emit(TraningSubmittedFailure(error: response.message));
        }
      } catch (e) {
        emit(TraningSubmittedFailure(error: e.toString()));
      }
    });
    on<Deletebysession>((event, emit) async {
      try {
        // Call the delete API
        await eventrepo.deleteEventById(id: event.eventsId);

        // Reload the horses after deletion
        var tenantId = await cacheService.getString(name: 'tenantId');

        final Sessions = await eventrepo.getAllEvent(tenantId: tenantId);
        List<EventModel> events = [];
        Sessions.forEach((e) => {
              if (e.raceType == "training") {events.add(e)}
            });
        emit(BysessionLoaded(sessions: events));
      } catch (e) {
        emit(Bysessionerror("Failed to delete horse"));
      }
    });
  }
}
