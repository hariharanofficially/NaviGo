part of 'treatment_bloc.dart';

sealed class TreatmentEvent extends Equatable {
  const TreatmentEvent();

  @override
  List<Object> get props => [];
}

class LoadTreatment extends TreatmentEvent {
  // final String id;
  const LoadTreatment();
  @override
  List<Object> get props => [];
}

class DeleteTreatment extends TreatmentEvent {
  final int treatmentId;

  DeleteTreatment({required this.treatmentId});
}
