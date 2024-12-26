import 'package:equatable/equatable.dart';

import '../../../../../../data/models/participant.dart';

abstract class ParticipantState extends Equatable {
  const ParticipantState();

  @override
  List<Object> get props => [];
}


class ParticipantLoading extends ParticipantState {}

class ParticipantLoaded extends ParticipantState {
  final List<Participant> participants; // Replace with actual participant model

  const ParticipantLoaded({required this.participants});

  @override
  List<Object> get props => [participants];
}

class ParticipantError extends ParticipantState {
  final String message;

  const ParticipantError(this.message);

  @override
  List<Object> get props => [message];
}
