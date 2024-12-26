import 'package:equatable/equatable.dart';

abstract class ParticipantEvent extends Equatable {
  const ParticipantEvent();

  @override
  List<Object> get props => [];
}

class LoadParticipants extends ParticipantEvent {
  String eventId;
  LoadParticipants({required this.eventId});
}
class DeleteParticipants extends ParticipantEvent {
  final int ParticipantsId;
  final String eventId;       // Include eventId to reload participants


  DeleteParticipants({required this.eventId, required this.ParticipantsId});
}