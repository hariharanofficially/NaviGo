part of 'training_bloc.dart';

sealed class TraningState extends Equatable {
  const TraningState();

  @override
  List<Object> get props => [];
}

class TraningLoading extends TraningState {}

class TraningLoaded extends TraningState {
  final List<Map<String, Object>> Traning;

  const TraningLoaded({required this.Traning});
  @override
  List<Object> get props => [Traning];
}

class TraningError extends TraningState {
  final String message;

  const TraningError(this.message);
  @override
  List<Object> get props => [message];
}
class TrainingDeleted extends TraningState{}