import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../../../../data/models/all_form_model.dart';

abstract class AddRiderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddRiderInitial extends AddRiderState {}

class AddRiderLoading extends AddRiderState {}

class RiderLoading extends AddRiderState {}

class RiderLoaded extends AddRiderState {
  final AllFormModel allFormModel;
  // final File? pickedImage; // Add the image as an optional field
  RiderLoaded({
    required this.allFormModel,
    // this.pickedImage,
  });
  // @override
  // List<Object> get props => [allFormModel];
}

class riderImage extends AddRiderState {
  final File pickedImage; // Add the image as an optional field

  riderImage({required this.pickedImage});
}

class AddRiderSuccess extends AddRiderState {
  final String message;
  AddRiderSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class Ridererror extends AddRiderState {
  final String message;
  Ridererror({required this.message});
  @override
  List<Object> get props => [message];
}

class AddRiderFailure extends AddRiderState {
  final String error;

  AddRiderFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class RiderImageUploadedSuccessfully extends AddRiderState {
  final String message;

  RiderImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class RiderImageUploadFailure extends AddRiderState {
  final String error;

  RiderImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
