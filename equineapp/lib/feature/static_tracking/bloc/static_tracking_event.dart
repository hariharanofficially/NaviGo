part of 'static_tracking_bloc.dart';

abstract class StaticTrackingEvent extends Equatable {
  const StaticTrackingEvent();
  @override
  List<Object> get props => [];
}

class StaticTrackingInitialEvent extends StaticTrackingEvent {
  final ParticipantModel participant;
  const StaticTrackingInitialEvent({required this.participant});
}

class StaticTrackingUpdatedParticipantEvent extends StaticTrackingEvent{}
class StaticTrackingMapViewChangeEvent extends StaticTrackingEvent {}

class StaticTrackingMapFullScreenEvent extends StaticTrackingEvent {}
