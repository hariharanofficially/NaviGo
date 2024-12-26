part of 'horseactivity_bloc.dart';

sealed class HorsesactivityState extends Equatable {
  const HorsesactivityState();

  @override
  List<Object> get props => [];
}

class HorsesactivityLoading extends HorsesactivityState {}


class HorsesactivityLoaded extends HorsesactivityState {
  final dynamic horsesactivity1; // Replace dynamic with the actual type
  final dynamic horsesactivity2; // Replace dynamic with the actual type
  final dynamic horsesactivity3; // Replace dynamic with the actual type

  const HorsesactivityLoaded({
    required this.horsesactivity1,
    required this.horsesactivity2,
    required this.horsesactivity3,
  });

  @override
  List<Object> get props => [horsesactivity1, horsesactivity2, horsesactivity3];
}

class HorsesactivityError extends HorsesactivityState {
  final String message;

  const HorsesactivityError(this.message);

  @override
  List<Object> get props => [message];
}