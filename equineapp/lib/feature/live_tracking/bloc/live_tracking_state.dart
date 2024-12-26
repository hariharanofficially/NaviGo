part of 'live_tracking_bloc.dart';

abstract class LiveTrackingState extends Equatable {
  const LiveTrackingState();
  @override
  List<Object> get props => [];
}

class LiveTrackingInitialState extends LiveTrackingState {
  @override
  List<Object> get props => [];
}

class LiveTrackingMapViewChangedState extends LiveTrackingState {
  final bool mapView;
  const LiveTrackingMapViewChangedState({required this.mapView});
  @override
  List<Object> get props => [mapView];
}

class LiveTrackingMapFullScreenChangedState extends LiveTrackingState {
  final bool fullScreen;
  const LiveTrackingMapFullScreenChangedState({required this.fullScreen});
  @override
  List<Object> get props => [fullScreen];
}

class LiveTrackingTrackerFeedLoadingState extends LiveTrackingState {}

class LiveTrackingTrackerShowMapState extends LiveTrackingState {}

class LiveTrackerRefreshDataLoadedState extends LiveTrackingState {
  final ParticipantModel? participant;
  final List<LatLng> latlng;
  const LiveTrackerRefreshDataLoadedState(
      {required this.participant, required this.latlng});
}

class LiveTrackingErrorState extends LiveTrackingState {
  final String message;
  const LiveTrackingErrorState({required this.message});
}

class LiveTrackingStartedState extends LiveTrackingState {
  final int startTime;
  const LiveTrackingStartedState({required this.startTime});
}

class LiveTrackingEndedState extends LiveTrackingState {
  final int endTime;
  const LiveTrackingEndedState({required this.endTime});
}

class LiveTrackingUpdateCurrentLocationState extends LiveTrackingState {
  List<LatLng> latlng;
  LiveTrackingUpdateCurrentLocationState({required this.latlng});
}
class LiveTrackingShareEnabledState extends LiveTrackingState {}

class LiveTrackingShareDisabledState extends LiveTrackingState {}
class LiveTrackerRefreshDataState extends LiveTrackingState {}