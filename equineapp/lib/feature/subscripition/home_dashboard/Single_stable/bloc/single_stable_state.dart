import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/roles.dart';

abstract class SingleStableDashboardState {}

class SingleStableDashboardInitial extends SingleStableDashboardState {}

class TabChangedState extends SingleStableDashboardState {
  final int selectedTab;

  TabChangedState(this.selectedTab);
}

class SingleStableInitLoaded extends SingleStableDashboardState {
  final int riderCount;
  final int stableCount;
  final int horseCount;
  final List<EventModel> events;
  final RolesModel role;

  SingleStableInitLoaded(
      {required this.riderCount,
      required this.stableCount,
      required this.horseCount,
      required this.events,
      required this.role});
}

class SingleStableLoading extends SingleStableDashboardState {}

class SingleStableInitLoadedFailed extends SingleStableDashboardState {
  final String message;
  SingleStableInitLoadedFailed(this.message);
}
