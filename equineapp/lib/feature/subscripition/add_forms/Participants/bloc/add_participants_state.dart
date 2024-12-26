import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../../data/models/all_form_model.dart';

abstract class AddParticipantsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddParticipantsInitial extends AddParticipantsState {}

class AddParticipantsLoading extends AddParticipantsState {}

class ParticipantsLoading extends AddParticipantsState {}

class ParticipantsLoaded extends AddParticipantsState {
  final AllFormModel allFormModel;
  // final File? pickedImage; // Add the image as an optional field

  ParticipantsLoaded({
    // this.pickedImage,
    required this.allFormModel,
  });
  @override
  List<Object> get props => [allFormModel];
}

class participantImage extends AddParticipantsState {
  final File pickedImage; // Add the image as an optional field

  participantImage({required this.pickedImage});
}

class Participantserror extends AddParticipantsState {
  final String message;
  Participantserror({required this.message});
  @override
  List<Object> get props => [message];
}

class AddParticipantsSuccess extends AddParticipantsState {
  final String message;
  AddParticipantsSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class AddParticipantsFailure extends AddParticipantsState {
  final String error;

  AddParticipantsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ParticipantsImageUploadedSuccessfully extends AddParticipantsState {
  final String message;

  ParticipantsImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class ParticipantsImageUploadFailure extends AddParticipantsState {
  final String error;

  ParticipantsImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
