part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardEventsLoadingState extends DashboardState {}

final class DashboardEventsLoadedState extends DashboardState {
  final List<EventModel> events;
  const DashboardEventsLoadedState({required this.events});
  @override
  List<Object> get props => [events];
}

class DashboardEventsEmptyState extends DashboardState {}

class DashboardEventsErrorState extends DashboardState {
  final String message;
  const DashboardEventsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}



