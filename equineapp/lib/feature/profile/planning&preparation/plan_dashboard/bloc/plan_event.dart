part of 'plan_bloc.dart';

sealed class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object> get props => [];
}

class LoadPlanning extends PlanEvent {
  final String horseId;

  LoadPlanning({required this.horseId});
  @override
  List<Object> get props => [];
}
