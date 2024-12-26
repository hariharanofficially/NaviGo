// add_stable_state.dart
import 'dart:io';

import 'package:EquineApp/data/models/stable_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddStableState extends Equatable {
  const AddStableState();

  @override
  List<Object> get props => [];
}

class AddStableInitial extends AddStableState {}

class AddStableLoading extends AddStableState {}

class AddStableSuccess extends AddStableState {
  final String message;
  const AddStableSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddStableFailure extends AddStableState {
  final String error;

  const AddStableFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class StableLoadedbyId extends AddStableState {
  final StableModel stable;

  const StableLoadedbyId({required this.stable});
}

class StableErrorbyId extends AddStableState {
  final String message;

  const StableErrorbyId(this.message);
}

class stableImage extends AddStableState {
  final File pickedImage; // Add the image as an optional field

  stableImage({required this.pickedImage});
}

class StableImageUploadedSuccessfully extends AddStableState {
  final String message;

  const StableImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class StableImageUploadFailure extends AddStableState {
  final String error;

  const StableImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
