abstract class EventsOrganizerEvent {}

class ChangeTabEvent extends EventsOrganizerEvent {
  final int selectedTab;

  ChangeTabEvent(this.selectedTab);
}

class EventsOrganizerLoadInitialDataEvent extends EventsOrganizerEvent {}
