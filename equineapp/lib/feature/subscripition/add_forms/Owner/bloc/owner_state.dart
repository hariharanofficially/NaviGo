part of 'owner_bloc.dart';

abstract class AddOwnerState extends Equatable {
  const AddOwnerState();

  @override
  List<Object> get props => [];
}

class AddOwnerInitial extends AddOwnerState {}

class AddOwnerLoading extends AddOwnerState {}

class AddOwnerSuccess extends AddOwnerState {
  final String message;
  const AddOwnerSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddOwnerFailure extends AddOwnerState {
  final String error;

  const AddOwnerFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class OwnerLoadedbyId extends AddOwnerState {
  final Ownername owner;

  const OwnerLoadedbyId({required this.owner});
}

class OwnerErrorbyId extends AddOwnerState {
  final String message;

  const OwnerErrorbyId(this.message);
}

class ownerImage extends AddOwnerState {
  final File pickedImage; // Add the image as an optional field

  ownerImage({required this.pickedImage});
}

class OwnerImageUploadedSuccessfully extends AddOwnerState {
  final String message;

  const OwnerImageUploadedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class OwnerImageUploadFailure extends AddOwnerState {
  final String error;

  const OwnerImageUploadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
