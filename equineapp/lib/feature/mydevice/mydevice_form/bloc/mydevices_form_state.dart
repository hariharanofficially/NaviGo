part of 'mydevices_form_bloc.dart';

abstract class MydevicesFormState extends Equatable {
  const MydevicesFormState();

  @override
  List<Object> get props => [];
}

final class MydevicesFormInitial extends MydevicesFormState {}

class MydevicesFormLoading extends MydevicesFormState {}

class MydevicesformLoaded extends MydevicesFormState {
  final RegisteredDevice device;

  MydevicesformLoaded({
    required this.device,
  });
}

class MydevicesFormerror extends MydevicesFormState {
  final String message;

  const MydevicesFormerror({required this.message});
}

class MydevicesFormSubmitting extends MydevicesFormState {}

class MydevicesFormSubmittedSuccessfully extends MydevicesFormState {
  final String message;

  const MydevicesFormSubmittedSuccessfully({required this.message});
}

class MydevicesFormSubmittedFailure extends MydevicesFormState {
  final String error;

  const MydevicesFormSubmittedFailure({required this.error});
}
