part of 'plan_form_bloc.dart';

sealed class PlanFormState extends Equatable {
  const PlanFormState();

  @override
  List<Object> get props => [];
}

final class PlanFormInitial extends PlanFormState {}

class PlanFormLoading extends PlanFormState {}

class PlanFormLoaded extends PlanFormState {
  final AllFormModel allFormModel;

  PlanFormLoaded({
    required this.allFormModel,
  });
}

class PlanFormSuccessfully extends PlanFormState {
  final String message;
  const PlanFormSuccessfully({required this.message});
}

class PlanFormerror extends PlanFormState {
  final String error;

  const PlanFormerror({required this.error});
  @override
  List<Object> get props => [error];
}
