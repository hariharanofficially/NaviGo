part of 'switchtenant_bloc.dart';

sealed class SwitchtenantEvent extends Equatable {
  const SwitchtenantEvent();

  @override
  List<Object> get props => [];
}


class LoadSwitch extends SwitchtenantEvent {
  // final String id;
  const LoadSwitch();
  @override
  List<Object> get props =>[];
}

class SwitchTenant extends SwitchtenantEvent {
  final String id;
  const SwitchTenant({required this.id});
}
