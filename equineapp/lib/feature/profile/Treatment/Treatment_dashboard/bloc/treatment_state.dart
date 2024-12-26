part of 'treatment_bloc.dart';

sealed class TreatmentState extends Equatable {
  const TreatmentState();

  @override
  List<Object> get props => [];
}

class TreatmentLoading extends TreatmentState {}

class TreatmentLoaded extends TreatmentState {
  final List<Map<String, Object>> Treatment;

  const TreatmentLoaded({required this.Treatment});

  @override
  List<Object> get props => [Treatment];
}

class TreatmentError extends TreatmentState {
  final String message;

  const TreatmentError(this.message);

  @override
  List<Object> get props => [message];
}
class TreatmentDeleted extends TreatmentState{}