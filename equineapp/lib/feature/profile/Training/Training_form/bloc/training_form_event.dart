part of 'training_form_bloc.dart';

sealed class TraningFormEvent extends Equatable {
  const TraningFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitFormTraining extends TraningFormEvent {
  final int? id;
  final String horseId;
  final String stableId;
  final String riderId;
  final String trainingId;
  final String surfaceId;
  final String distance;
  final String duration;
  final String trainingDatetime;
  final String walk;
  final String trot;
  final String canter;
  final String gallop;
  const SubmitFormTraining({
    this.id,
    required this.horseId,
    required this.stableId,
    required this.riderId,
    required this.trainingId,
    required this.surfaceId,
    required this.distance,
    required this.duration,
    required this.trainingDatetime,
    required this.walk,
    required this.trot,
    required this.canter,
    required this.gallop,
  });
}

class LoadFetchtraining extends TraningFormEvent {}

class LoadFetchtrainingByid extends TraningFormEvent {
  final int id;

  LoadFetchtrainingByid({required this.id});
}

class SubmitTrainingType extends TraningFormEvent {
  final int? id;
  final String name;
  SubmitTrainingType({this.id, required this.name});
}

class SubmitSurfaceType extends TraningFormEvent {
  final int? id;
  final String name;
  SubmitSurfaceType({this.id, required this.name});
}

class DeleteTrainingType extends TraningFormEvent {
  final int trainingtypeId;

  DeleteTrainingType({required this.trainingtypeId});
}

class DeleteSurfaceType extends TraningFormEvent {
  final int surfacetypeId;

  DeleteSurfaceType({required this.surfacetypeId});
}
