import 'package:equatable/equatable.dart';

import '../../../../../../data/models/trainermodel.dart';

abstract class TrainersState extends Equatable {
  const TrainersState();

  @override
  List<Object> get props => [];
}

class TrainersLoading extends TrainersState {}

class TrainersLoaded extends TrainersState {
  final List<TrainerModel> Trainers;

  const TrainersLoaded({required this.Trainers});

  @override
  List<Object> get props => [Trainers];
}

class TrainersError extends TrainersState {
  final String message;

  const TrainersError(this.message);

  @override
  List<Object> get props => [message];
}