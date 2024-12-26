//import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/participant_model.dart';
import '../../../data/repo/repo.dart';

part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  TrackerBloc() : super(TrackerInitialState()) {
    on<TrackerParticipantsFetchEvent>((event, emit) async {
      emit(TrackerParticipantsLoadingState());
      try {
        final int trackerDeviceId = await cacheRepo.getInt(name: 'myTrackerId');
        final bool isPaired = await cacheRepo.getBoolean(name: 'isPaired');
        //final int trackerDeviceId = 243;
        //bool isPaired = true;

        ParticipantModel? currentParticipant;
        List<ParticipantModel> eventParticipants = [];

        if (isPaired) {
          currentParticipant = await trackerRepo.getTrackerParticipant(
              trackerDeviceId: trackerDeviceId.toString());

          eventParticipants = await trackerRepo.getEventParticipants(
              id: currentParticipant!.eventId.toString());
        }

        // if (eventParticipants.isEmpty) {
        //   emit(TrackerEventParticipantsEmptyState());
        // } else {
        emit(TrackerParticipantLoadedState(
            currentParticipant: currentParticipant,
            eventParticipants: eventParticipants,
            isPaired: isPaired));
        //}
      } catch (e) {
        emit(TrackerParticipantsErrorState(message: e.toString()));
      }
    });
  }
}
