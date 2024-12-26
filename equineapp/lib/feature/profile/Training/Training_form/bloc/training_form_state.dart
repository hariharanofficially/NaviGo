part of 'training_form_bloc.dart';

sealed class TraningFormState extends Equatable {
  const TraningFormState();

  @override
  List<Object> get props => [];
}

final class TraningFormInitial extends TraningFormState {}

class TrainingLoading extends TraningFormState {}

class TrainingLoaded extends TraningFormState {
  final AllFormModel allFormModel;

  TrainingLoaded({
    required this.allFormModel,
  });
}

class Trainingerror extends TraningFormState {
  final String message;

  const Trainingerror({required this.message});
  @override
  List<Object> get props => [message];
}

class TraningFormSuccessfully extends TraningFormState {
  final String message;
  const TraningFormSuccessfully({required this.message});
}

class TraningFormFailure extends TraningFormState {
  final String error;
  const TraningFormFailure({required this.error});
}

class TrainingTypeCreateSuccess extends TraningFormState {
  final List<TrainingType> types;
  TrainingTypeCreateSuccess({required this.types});
}

class TrainingTypeCreateFailed extends TraningFormState {
  final String error;
  const TrainingTypeCreateFailed({required this.error});
}

class SurfaceTypeCreateSuccess extends TraningFormState {
  final List<SurfaceType> types;
  SurfaceTypeCreateSuccess({required this.types});
}

class SurfaceTypeCreateFailed extends TraningFormState {
  final String error;
  const SurfaceTypeCreateFailed({required this.error});
}

class TrainingTypeDeleted extends TraningFormState {
  final List<TrainingType> types;

  TrainingTypeDeleted({required this.types});
}

class SurfaceTypeDeleted extends TraningFormState {
  final List<SurfaceType> types;

  SurfaceTypeDeleted({required this.types});
}
