part of 'body_form_bloc.dart';

sealed class BodyFormEvent extends Equatable {
  const BodyFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitBodyMeasurement extends BodyFormEvent {
  final int? id;
  final HorseModel horse;
  final String dateOfBirth;
  final String weight;
  SubmitBodyMeasurement(
      {this.id,
      required this.horse,
      required this.dateOfBirth,
      required this.weight});
}

class LoadBodyformByid extends BodyFormEvent {
  final int id;
  const LoadBodyformByid({required this.id});
  @override
  List<Object> get props => [];
}
