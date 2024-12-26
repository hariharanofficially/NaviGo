import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/roles.dart';

abstract class EventsOrganizerState {}

class EventsOrganizerInitial extends EventsOrganizerState {}

class TabChangedState extends EventsOrganizerState {
  final int selectedTab;

  TabChangedState(this.selectedTab);
}

class EventsOrganizerInitLoaded extends EventsOrganizerState {
  final int eventCount;
  final int stableCount;
  final int horseCount;
  final List<EventModel> events;
  final RolesModel role;

  EventsOrganizerInitLoaded(
      {required this.stableCount,
      required this.horseCount,
      required this.eventCount,
      required this.events,
      required this.role});
}

class EventsOrganizerInitLoadedFailed extends EventsOrganizerState {
  final String message;
  EventsOrganizerInitLoadedFailed(this.message);
}

class EventOrganizerLoading extends EventsOrganizerState {}
