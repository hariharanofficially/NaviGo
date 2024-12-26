import 'package:equatable/equatable.dart';

abstract class MockRaceDashboardEvent extends Equatable {
  const MockRaceDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadMockRace extends MockRaceDashboardEvent {}

class DeleteMockRace extends MockRaceDashboardEvent {
  final int eventsId;

  DeleteMockRace({required this.eventsId});
}
