import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../../../../data/models/all_form_model.dart';

abstract class AddTrainerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTrainerInitial extends AddTrainerState {}

class AddTrainerLoading extends AddTrainerState {}

class TrainerLoading extends AddTrainerState {}

class TrainerLoaded extends AddTrainerState {
  final AllFormModel allFormModel;
  // final File? pickedImage; // Add the image as an optional field
  TrainerLoaded({
    required this.allFormModel,
    // this.pickedImage,
  });
  // @override
  // List<Object> get props => [allFormModel];
}

class TrainerImage extends AddTrainerState {
  final File pickedImage; // Add the image as an optional field

  TrainerImage({required this.pickedImage});
}

class AddTrainerSuccess extends AddTrainerState {
  final String message;
  AddTrainerSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class Trainererror extends AddTrainerState {
  final String message;
  Trainererror({required this.message});
  @override
  List<Object> get props => [message];
}

class AddTrainerFailure extends AddTrainerState {
  final String error;

  AddTrainerFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class TrainerImageUploadedSuccessfully extends AddTrainerState {
  final String message;

  TrainerImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class TrainerImageUploadFailure extends AddTrainerState {
  final String error;

  TrainerImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
