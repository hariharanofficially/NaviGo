import 'dart:io';

import 'package:EquineApp/data/models/horse_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/all_form_model.dart';

abstract class AddHorseState extends Equatable {
  const AddHorseState();

  @override
  List<Object> get props => [];
}

class AddHorseInitial extends AddHorseState {}

class HorseLoading extends AddHorseState {}

class HorseLoaded extends AddHorseState {
  final AllFormModel allFormModel;
  // final File? pickedImage; // Add the image as an optional field

  HorseLoaded({required this.allFormModel, });
}

class horseImage extends AddHorseState {
  final File pickedImage; // Add the image as an optional field

  horseImage({required this.pickedImage});
}
// class HorseLoaded extends AddHorseState {
//   final AllFormModel allFormModel;
//   final String? message;
//   const HorseLoaded({required this.allFormModel, this.message});
//   @override
//   List<Object> get props => [allFormModel];
// }

class Horseerror extends AddHorseState {
  final String message;

  const Horseerror({required this.message});
  @override
  List<Object> get props => [message];
}

class FormSubmitting extends AddHorseState {}

class FormSubmittedSuccessfully extends AddHorseState {
  final String message;
  const FormSubmittedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class FormSubmittedFailure extends AddHorseState {
  final String error;
  const FormSubmittedFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class DateSelected extends AddHorseState {
  final String selectedDate;
  const DateSelected(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class HorseDetailsLoaded extends AddHorseState {
  final HorseModel horse;
  final AllFormModel? allFormData; // Define the type according to your model
  const HorseDetailsLoaded({
    required this.horse,
    this.allFormData,
  });
}

// // add_horse_state.dart
// class ImagePicked extends AddHorseState {
//   final File image;
//   const ImagePicked({required this.image});
// }

class HorseImageUploadedSuccessfully extends AddHorseState {
  final String message;

  const HorseImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class HorseImageUploadFailure extends AddHorseState {
  final String error;

  const HorseImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
