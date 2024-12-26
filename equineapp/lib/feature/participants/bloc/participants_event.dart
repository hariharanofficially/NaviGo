part of 'participants_bloc.dart';

abstract class ParticipantsEvent extends Equatable {
  const ParticipantsEvent();
  @override
  List<Object> get props => [];
}

class ParticipantsFetchEvent extends ParticipantsEvent {
  final String id;
  const ParticipantsFetchEvent({required this.id});
  @override
  List<Object> get props => [];
}
