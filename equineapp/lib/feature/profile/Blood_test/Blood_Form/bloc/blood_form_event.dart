part of 'blood_form_bloc.dart';

sealed class BloodFormEvent extends Equatable {
  const BloodFormEvent();

  @override
  List<Object> get props => [];
}

class LoadBloodform extends BloodFormEvent {}

class LoadBloodTestResultsById extends BloodFormEvent {
  final int id;

  const LoadBloodTestResultsById({required this.id});

  @override
  List<Object> get props => [id];
}

class SubmitBloodTestType extends BloodFormEvent {
  final int? id;
  final String name;
  SubmitBloodTestType({this.id, required this.name});
}

class SubmitFormBlood extends BloodFormEvent {
  final int? id;
  final String horseId;
  final String BloodtestElementId;
  final String BloodtestTypeId;
  final String result;
  final String dateOfBirth;

  const SubmitFormBlood({
    this.id,
    required this.horseId,
    required this.BloodtestElementId,
    required this.dateOfBirth,
    required this.BloodtestTypeId,
    required this.result,
  });
}

class DeleteBloodTestType extends BloodFormEvent {
  final int BloodTestTypeId;

  DeleteBloodTestType({required this.BloodTestTypeId});
}
