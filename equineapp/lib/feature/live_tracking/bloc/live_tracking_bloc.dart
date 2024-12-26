// import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

import '../../../data/models/participant_model.dart';
// import '../../../data/models/tracker_feed_data.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';

part 'live_tracking_event.dart';
part 'live_tracking_state.dart';

class LiveTrackingBloc extends Bloc<LiveTrackingEvent, LiveTrackingState> {
  bool mapDefaultView = true;
  bool mapFullScreenView = false;
  int trackingStartTime = DateTime.now().millisecondsSinceEpoch;
  int trackingEndTime = DateTime.now().millisecondsSinceEpoch;
  late List<LatLng> latlng;
  Logger logger = new Logger();
//  ParticipantModel
  LiveTrackingBloc() : super(LiveTrackingInitialState()) {
    on<LiveTrackingInitialEvent>((event, emit) async {
      trackingStartTime = await cacheRepo.getInt(name: 'trackStartTime');
      trackingEndTime = await cacheRepo.getInt(name: 'trackEndTime');
      bool isRunEnabled = await cacheRepo.getBoolean(name: 'isRunEnabled');

      if (isRunEnabled) {
        emit(LiveTrackingStartedState(startTime: trackingStartTime));
      } else {
        emit(LiveTrackingEndedState(endTime: trackingEndTime));
      }
      bool isShareEnabled = await cacheRepo.getBoolean(name: 'isShareEnabled');
      if (isShareEnabled) {
        emit(LiveTrackingShareEnabledState());
      } else {
        emit(LiveTrackingShareDisabledState());
      }
      latlng = schedulerService.getRoutePoints();
      emit(LiveTrackingUpdateCurrentLocationState(latlng: latlng));
    });

    on<LiveTrackingMapViewChangeEvent>((event, emit) {
      mapDefaultView = !mapDefaultView;
      emit(LiveTrackingMapViewChangedState(mapView: mapDefaultView));
    });

    on<LiveTrackingMapFullScreenEvent>((event, emit) {
      mapFullScreenView = !mapFullScreenView;
      emit(
          LiveTrackingMapFullScreenChangedState(fullScreen: mapFullScreenView));
    });

    on<LiveTrackerStartEvent>((event, emit) async {
      cacheRepo.setBoolean(name: 'isRunEnabled', value: true);
      cacheRepo.setBoolean(name: 'isShareEnabled', value: true);
      trackingStartTime = DateTime.now().millisecondsSinceEpoch;
      cacheRepo.setInt(name: 'trackStartTime', value: trackingStartTime);
      await BackgroundLocation.startLocationService();
      emit(LiveTrackingStartedState(startTime: trackingStartTime));
    });
    on<LiveTrackerStopEvent>((event, emit) async {
      cacheRepo.setBoolean(name: 'isRunEnabled', value: false);
      cacheRepo.setBoolean(name: 'isShareEnabled', value: false);
      trackingEndTime = DateTime.now().millisecondsSinceEpoch;
      cacheRepo.setInt(name: 'trackEndTime', value: trackingEndTime);
      await BackgroundLocation.stopLocationService();
      emit(LiveTrackingEndedState(endTime: trackingEndTime));
    });
    on<LiveTrackerShareEvent>((event, emit) async {
      cacheRepo.setBoolean(name: 'isShareEnabled', value: true);
      emit(LiveTrackingShareEnabledState());
    });
    on<LiveTrackerUnShareEvent>((event, emit) async {
      cacheRepo.setBoolean(name: 'isShareEnabled', value: false);
      emit(LiveTrackingShareDisabledState());
    });
    on<LiveTrackerRefreshEvent>((event, emit) async {
      try {
        final int trackerDeviceId = await cacheRepo.getInt(name: 'myTrackerId');
        //final int trackerDeviceId = 243;
        logger.d(trackerDeviceId);
        final ParticipantModel? currentParticipant =
        await trackerRepo.getTrackerParticipant(
            trackerDeviceId: trackerDeviceId.toString());
        logger.d(currentParticipant);
        latlng = schedulerService.getRoutePoints();
        emit(LiveTrackerRefreshDataState());
        emit(LiveTrackerRefreshDataLoadedState(
            participant: currentParticipant,
            latlng: latlng));
      } catch (e) {
        emit(LiveTrackingErrorState(message: e.toString()));
      }
    });
  }
}
