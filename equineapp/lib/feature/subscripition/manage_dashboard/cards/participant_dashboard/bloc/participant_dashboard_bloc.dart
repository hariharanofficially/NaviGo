import 'package:bloc/bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'participant_dashboard_event.dart';
import 'participant_dashboard_state.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  ParticipantBloc() : super(ParticipantLoading()) {
    on<LoadParticipants>((event, emit) async {
      try {
        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        final participants =  await participantrepo.getAllParticipant(id: event.eventId);
        // final participants = ["Al Maghaweer Stables", "MRM Stables", "F3 Stables"]; // Replace with actual data fetching logic
        emit(ParticipantLoaded(participants:participants));
      } catch (e) {
        emit(ParticipantError("Failed to load participants"));
      }
    });
    on<DeleteParticipants>((event, emit) async {
      try {
        // Call the delete API
        await participantrepo.deleteAllParticipant(id:event.ParticipantsId);

        // Reload the horses after deletion
        final participants =  await participantrepo.getAllParticipant(id: event.eventId);

        emit(ParticipantLoaded(participants: participants));
      } catch (e) {
        emit(ParticipantError("Failed to delete horse"));
      }
    });
  }
}

