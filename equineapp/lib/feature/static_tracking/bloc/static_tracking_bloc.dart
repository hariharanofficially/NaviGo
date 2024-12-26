// import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/participant_model.dart';
import '../../../data/models/tracker_feed_data.dart';
import '../../../data/repo/repo.dart';

part 'static_tracking_event.dart';
part 'static_tracking_state.dart';

class StaticTrackingBloc extends Bloc<StaticTrackingEvent, StaticTrackingState> {
  bool mapDefaultView = true;
  bool mapFullScreenView = false;

  StaticTrackingBloc() : super(StaticTrackingInitialState()) {
    on<StaticTrackingInitialEvent>((event, emit) async {
      emit(StaticTrackingTrackerFeedLoadingState());
      try {
        final ParticipantModel participant = event.participant;
        final List<TrackerFeedData> feedDataList =
          await trackerRepo.getEventParticipantTrackerFeed(
              eventId: participant.eventId.toString(),
              participantId: participant.id.toString());

        emit(StaticTrackingTrackerFeedLoadedState(feedDataList: feedDataList));
        emit(StaticTrackingTrackerShowMapState());
      } catch (e) {
        emit(StaticTrackingTrackerFeedLoadFailedState(message: e.toString()));
      }
    });

    on<StaticTrackingMapViewChangeEvent>((event, emit) {
      mapDefaultView = !mapDefaultView;
      emit(StaticTrackingMapViewChangedState(mapView: mapDefaultView));
    });

    on<StaticTrackingMapFullScreenEvent>((event, emit) {
      mapFullScreenView = !mapFullScreenView;
      emit(StaticTrackingMapFullScreenChangedState(fullScreen: mapFullScreenView));
    });
  }
}
