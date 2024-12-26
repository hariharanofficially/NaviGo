// add_event_state.dart
import 'dart:io';

import 'package:equatable/equatable.dart';
import '../../../../../data/models/all_form_model.dart';

abstract class AddEventState extends Equatable {
  const AddEventState();

  @override
  List<Object> get props => [];
}

class AddEventInitial extends AddEventState {}

class AddEventLoading extends AddEventState {}

class eventLoading extends AddEventState {}

class eventLoaded extends AddEventState {
  final AllFormModel allFormModel;
  // final File? pickedImage;
  const eventLoaded({
    required this.allFormModel,
    // this.pickedImage
  });
  @override
  List<Object> get props => [allFormModel];
}

class eventsImage extends AddEventState {
  final File pickedImage; // Add the image as an optional field

  eventsImage({required this.pickedImage});
}

class eventerror extends AddEventState {
  final String message;
  const eventerror({required this.message});

  @override
  List<Object> get props => [message];
}

class AddEventSuccess extends AddEventState {
  final String message;
  const AddEventSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddRaceEventSuccess extends AddEventState {
  final String message;
  const AddRaceEventSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddMockEventSuccess extends AddEventState {
  final String message;
  const AddMockEventSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddTrainingEventSuccess extends AddEventState {
  final String message;
  const AddTrainingEventSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddEventFailure extends AddEventState {
  final String error;

  const AddEventFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class EventImageUploadedSuccessfully extends AddEventState {
  final String message;

  EventImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class EventImageUploadFailure extends AddEventState {
  final String error;

  EventImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
