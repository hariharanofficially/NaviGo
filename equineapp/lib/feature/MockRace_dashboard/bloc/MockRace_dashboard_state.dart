import 'package:equatable/equatable.dart';

import '../../../../data/models/event_model.dart';

abstract class MockRaceDashboardState extends Equatable {
  const MockRaceDashboardState();

  @override
  List<Object> get props => [];
}


class MockRaceLoading extends MockRaceDashboardState {}

class MockRaceLoaded extends MockRaceDashboardState {
  final List<EventModel> MockRace; // Replace with your actual event model

  const MockRaceLoaded({required this.MockRace});

  @override
  List<Object> get props => [MockRace];
}

class MockRaceError extends MockRaceDashboardState {
  final String message;

  const MockRaceError(this.message);

  @override
  List<Object> get props => [message];
}
