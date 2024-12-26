part of 'static_tracking_bloc.dart';

abstract class StaticTrackingState extends Equatable {
  const StaticTrackingState();
  @override
  List<Object> get props => [];
}

class StaticTrackingInitialState extends StaticTrackingState {
  @override
  List<Object> get props => [];
}

class StaticTrackingMapViewChangedState extends StaticTrackingState {
  final bool mapView;
  const StaticTrackingMapViewChangedState({required this.mapView});
  @override
  List<Object> get props => [mapView];
}

class StaticTrackingMapFullScreenChangedState extends StaticTrackingState {
  final bool fullScreen;
  const StaticTrackingMapFullScreenChangedState({required this.fullScreen});
  @override
  List<Object> get props => [fullScreen];
}

class StaticTrackingTrackerFeedLoadingState extends StaticTrackingState {}

class StaticTrackingTrackerShowMapState extends StaticTrackingState {}

class StaticTrackingTrackerFeedLoadedState extends StaticTrackingState {
  final List<TrackerFeedData> feedDataList;
  const StaticTrackingTrackerFeedLoadedState({required this.feedDataList});
}
class StaticTrackingParticipantUpdatedState extends StaticTrackingState{
  ParticipantModel participant;
  StaticTrackingParticipantUpdatedState({required this.participant});
}

class StaticTrackingTrackerFeedLoadFailedState extends StaticTrackingState {
  final String message;
  const StaticTrackingTrackerFeedLoadFailedState({required this.message});
}
