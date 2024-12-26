part of 'blood_form_bloc.dart';

sealed class BloodFormState extends Equatable {
  const BloodFormState();

  @override
  List<Object> get props => [];
}

final class BloodFormInitial extends BloodFormState {}

class BloodFormLoading extends BloodFormState {}

class BloodFormLoaded extends BloodFormState {
  final AllFormModel allFormModel;

  BloodFormLoaded({
    required this.allFormModel,
  });
}

class BloodFormerror extends BloodFormState {
  final String message;

  const BloodFormerror({required this.message});
  @override
  List<Object> get props => [message];
}

class BloodTestTypeCreateSuccess extends BloodFormState {
  final List<BloodTestType> types;
  BloodTestTypeCreateSuccess({required this.types});
}

class BloodTestTypeCreateFailed extends BloodFormState {
  final String error;
  const BloodTestTypeCreateFailed({required this.error});
}

class BloodtestFormSuccessfully extends BloodFormState {
  final String message;
  const BloodtestFormSuccessfully({required this.message});
}

class BloodFormFailure extends BloodFormState {
  final String error;
  const BloodFormFailure({required this.error});
}

class BloodTestTypeDeleted extends BloodFormState {
  final List<BloodTestType> types;

  BloodTestTypeDeleted({required this.types});
}
