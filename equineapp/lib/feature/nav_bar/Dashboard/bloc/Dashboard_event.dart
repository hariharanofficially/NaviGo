// event_bloc.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToAddStableEvent extends DashboardEvent {
  const NavigateToAddStableEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToAddHorseEvent extends DashboardEvent {
  const NavigateToAddHorseEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToAddRiderEvent extends DashboardEvent {
  const NavigateToAddRiderEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToPlanEvent extends DashboardEvent {
  final String screen;

  const NavigateToPlanEvent(this.screen);

  @override
  List<Object?> get props => [screen];
}
