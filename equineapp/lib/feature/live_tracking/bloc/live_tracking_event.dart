part of 'live_tracking_bloc.dart';

abstract class LiveTrackingEvent extends Equatable {
  const LiveTrackingEvent();
  @override
  List<Object> get props => [];
}

class LiveTrackingInitialEvent extends LiveTrackingEvent {
  final ParticipantModel participant;
  const LiveTrackingInitialEvent({required this.participant});
}

class LiveTrackerStartEvent extends LiveTrackingEvent {}

class LiveTrackerStopEvent extends LiveTrackingEvent {}

class LiveTrackerShareEvent extends LiveTrackingEvent {}

class LiveTrackerUnShareEvent extends LiveTrackingEvent {}

class LiveTrackerRefreshEvent extends LiveTrackingEvent {}

class LiveTrackingMapViewChangeEvent extends LiveTrackingEvent {}

class LiveTrackingMapFullScreenEvent extends LiveTrackingEvent {}
