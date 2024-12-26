part of 'tracker_bloc.dart';

abstract class TrackerState extends Equatable {
  const TrackerState();
  @override
  List<Object> get props => [];
}

class TrackerInitialState extends TrackerState {}

class TrackerParticipantsLoadingState extends TrackerState {}

final class TrackerParticipantLoadedState extends TrackerState {
final ParticipantModel? currentParticipant;
final List<ParticipantModel> eventParticipants;
final bool isPaired;
const TrackerParticipantLoadedState({
        required this.currentParticipant,
        required this.eventParticipants,
        required this.isPaired});
}

class TrackerEventParticipantsEmptyState extends TrackerState {}

class TrackerParticipantsErrorState extends TrackerState {
final String message;
const TrackerParticipantsErrorState({required this.message});
@override
List<Object> get props => [message];
}
