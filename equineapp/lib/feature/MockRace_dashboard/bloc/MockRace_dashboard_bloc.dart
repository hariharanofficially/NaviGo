import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:logger/logger.dart';
import '../../../../data/service/service.dart';
import '../../../data/models/event_model.dart';
import 'MockRace_dashboard_event.dart';
import 'MockRace_dashboard_state.dart';

class MockRaceDashboardBloc
    extends Bloc<MockRaceDashboardEvent, MockRaceDashboardState> {
  Logger logger = new Logger();
  MockRaceDashboardBloc() : super(MockRaceLoading()) {
    on<LoadMockRace>((event, emit) async {
      try {
        var tenantId = await cacheService.getString(name: 'tenantId');

        final eventList = await eventrepo.getAllEvent(tenantId: tenantId);
        List<EventModel> event = [];
        eventList.forEach((e) => {
              if (e.category == "mock") {event.add(e)}
            });
        logger.d(event);
        emit(MockRaceLoaded(MockRace: event));
      } catch (e) {
        emit(MockRaceError('Failed to fetch MockRace'));
      }
    });
    on<DeleteMockRace>((event, emit) async {
      try {
        // Call the delete API
        await eventrepo.deleteEventById(id: event.eventsId);

        // Reload the horses after deletion
        var tenantId = await cacheService.getString(name: 'tenantId');
        final eventList = await eventrepo.getAllEvent(tenantId: tenantId);
        List<EventModel> events = [];
        eventList.forEach((e) => {
              if (e.category == "mock") {events.add(e)}
            });
        emit(MockRaceLoaded(MockRace: events));
      } catch (e) {
        emit(MockRaceError("Failed to delete horse"));
      }
    });
  }
}
