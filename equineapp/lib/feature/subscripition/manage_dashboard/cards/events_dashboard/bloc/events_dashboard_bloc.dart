import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:logger/logger.dart';
import '../../../../../../data/models/event_model.dart';
import '../../../../../../data/service/service.dart';
import 'events_dashboard_event.dart';
import 'events_dashboard_state.dart';

class EventsDashboardBloc
    extends Bloc<EventsDashboardEvent, EventsDashboardState> {
  Logger logger = new Logger();
  EventsDashboardBloc() : super(EventsLoading()) {
    on<LoadEvents>((event, emit) async {
      try {
        var tenantId = await cacheService.getString(name: 'tenantId');

        final eventList = await eventrepo.getAllEvent(tenantId: tenantId);
        List<EventModel> event = [];
        eventList.forEach( (e) => {
          if (e.raceType == "race") {
            event.add(e)
          }
        });
        logger.d(event);
        emit(EventsLoaded(events: event));
      } catch (e) {
        emit(EventsError('Failed to fetch events'));
      }
    });
    // Handle the DeleteHorse event
    on<DeleteEvents>((event, emit) async {
      try {
        // Call the delete API
        await eventrepo.deleteEventById(id:event.eventsId);

        // Reload the horses after deletion
        var tenantId = await cacheService.getString(name: 'tenantId');
        final events = await eventrepo.getAllEvent(tenantId: tenantId);
        emit(EventsLoaded(events: events));
      } catch (e) {
        emit(EventsError("Failed to delete horse"));
      }
    });
  }
}
