import 'package:equatable/equatable.dart';

abstract class AddParticipantsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitParticipantsForm extends AddParticipantsEvent {
  final int? id;
  final String ownername;
  final String stablename;
  final String startNumber;
  final String eventId;
  final String riderId;
  final String horseId;
  final String deviceId;

  SubmitParticipantsForm(
      {this.id,
      required this.ownername,
      required this.stablename,
      required this.startNumber,
      required this.eventId,
      required this.riderId,
      required this.horseId,
      required this.deviceId});
}

class Loadfetchparticipant extends AddParticipantsEvent {}

class LoadparticipantDetails extends AddParticipantsEvent {
  final int participantId;
  LoadparticipantDetails({required this.participantId});
}

class PickImage extends AddParticipantsEvent {}

class UploadPartImage extends AddParticipantsEvent {}
