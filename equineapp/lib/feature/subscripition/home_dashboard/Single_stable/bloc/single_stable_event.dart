
abstract class SingleStableDashboardEvent {}

class ChangeTabEvent extends SingleStableDashboardEvent {
  final int selectedTab;

  ChangeTabEvent(this.selectedTab);
}

class SingleStableLoadInitialDataEvent extends SingleStableDashboardEvent {}
