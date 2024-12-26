part of 'owner_bloc.dart';

abstract class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object> get props => [];
}

class OwnerLoading extends OwnerState {}

class OwnerLoaded extends OwnerState {
  final List<Ownername> Owner; // Replace with actual participant model

  const OwnerLoaded({required this.Owner});

  @override
  List<Object> get props => [Owner];
}

class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);

  @override
  List<Object> get props => [message];
}
