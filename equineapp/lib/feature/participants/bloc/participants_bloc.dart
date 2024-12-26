// import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/participant_model.dart';
import '../../../data/repo/repo.dart';

part 'participants_event.dart';
part 'participants_state.dart';

class ParticipantsBloc extends Bloc<ParticipantsEvent, ParticipantsState> {
  ParticipantsBloc() : super(ParticipantsInitialState()) {
    on<ParticipantsFetchEvent>((event, emit) async {
      emit(ParticipantsLoadingState());

      try {
        final String id = event.id;
        final participants = await trackerRepo.getEventParticipants(id: id);
        emit(ParticipantsLoadedState(participants: participants));
      } catch (e) {
        emit(ParticipantsErrorState(message: e.toString()));
      }
    });
  }
}
