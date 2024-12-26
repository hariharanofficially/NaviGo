part of 'tracker_bloc.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();
  @override
  List<Object> get props => [];
}

class TrackerInitialEvent extends TrackerEvent {}

class TrackerParticipantsFetchEvent extends TrackerEvent {
  const TrackerParticipantsFetchEvent();
  @override
  List<Object> get props => [];
}

