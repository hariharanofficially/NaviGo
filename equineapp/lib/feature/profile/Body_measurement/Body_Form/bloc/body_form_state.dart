part of 'body_form_bloc.dart';

sealed class BodyFormState extends Equatable {
  const BodyFormState();

  @override
  List<Object> get props => [];
}

final class BodyFormInitial extends BodyFormState {}

class BodyFormLoading extends BodyFormState {}

class AddBodymeasurementSuccess extends BodyFormState {
  final String message;
  AddBodymeasurementSuccess({required this.message});
}

class AddBodymeasurementFailure extends BodyFormState {
  final String error;

  AddBodymeasurementFailure({required this.error});
}

class BodyFormLoaded extends BodyFormState {
  final BodyModel body;
  BodyFormLoaded({
    required this.body,
  });
}

class BodyFormerror extends BodyFormState {
  final String error;

  BodyFormerror({required this.error});
}
