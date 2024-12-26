part of 'plan_bloc.dart';

sealed class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object> get props => [];
}

class PlanLoading extends PlanState {}

class PlanLoaded extends PlanState {
  final List<Map<String, dynamic>> planning; // 'dynamic' allows mixed types

  const PlanLoaded({required this.planning});

  @override
  List<Object> get props => [planning];
}

class PlanError extends PlanState {
  final String message;

  const PlanError(this.message);

  @override
  List<Object> get props => [message];
}
