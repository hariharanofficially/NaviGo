part of 'participants_bloc.dart';

abstract class ParticipantsState extends Equatable {
  const ParticipantsState();

  @override
  List<Object> get props => [];
}

class ParticipantsInitialState extends ParticipantsState {
  @override
  List<Object> get props => [];
}

class ParticipantsLoadingState extends ParticipantsState {}

final class ParticipantsLoadedState extends ParticipantsState {
  final List<ParticipantModel> participants;
  const ParticipantsLoadedState({required this.participants});
  @override
  List<Object> get props => [participants];
}

class ParticipantsEmptyState extends ParticipantsState {}

class ParticipantsErrorState extends ParticipantsState {
  final String message;
  const ParticipantsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
