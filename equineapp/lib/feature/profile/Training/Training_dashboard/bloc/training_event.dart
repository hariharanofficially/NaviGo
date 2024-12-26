part of 'training_bloc.dart';

sealed class TraningEvent extends Equatable {
  const TraningEvent();

  @override
  List<Object> get props => [];
}

class LoadTraning extends TraningEvent {}

class DeleteTraining extends TraningEvent {
  final int trainingId;

  DeleteTraining({required this.trainingId});
}
