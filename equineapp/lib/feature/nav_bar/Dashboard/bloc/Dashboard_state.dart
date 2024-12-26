// state_bloc.dart
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardState {
  @override
  List<Object?> get props => [];
}

class NavigateToStable extends DashboardState {
  @override
  List<Object?> get props => [];
}

class NavigateToHorse extends DashboardState {
  @override
  List<Object?> get props => [];
}

class NavigateToRider extends DashboardState {
  @override
  List<Object?> get props => [];
}

class NavigateToPlan extends DashboardState {
  final String screen;

  const NavigateToPlan(this.screen);

  @override
  List<Object?> get props => [screen];
}
