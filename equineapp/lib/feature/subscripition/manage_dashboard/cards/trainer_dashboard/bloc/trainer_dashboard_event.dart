import 'package:equatable/equatable.dart';

abstract class TrainersEvent extends Equatable {
  const TrainersEvent();

  @override
  List<Object> get props => [];
}

class LoadTrainers extends TrainersEvent {}


class DeleteTrainer extends TrainersEvent {
  final int TrainerId;

  DeleteTrainer({required this.TrainerId});
}
