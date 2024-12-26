part of 'switchtenant_bloc.dart';

sealed class SwitchtenantState extends Equatable {
  const SwitchtenantState();
  
  @override
  List<Object> get props => [];
}


class SwitchLoading extends SwitchtenantState{}

class SwitchLoaded extends SwitchtenantState{
    final UserTenantModel Switch;
    final String tenantId;

  const SwitchLoaded({required this.Switch, required this.tenantId});

  @override
  List<Object> get props => [Switch];
}

class SwitchedTenant extends SwitchtenantState{}

class SwitchError extends SwitchtenantState {
  final String message;

  const SwitchError(this.message);

  @override
  List<Object> get props => [message];
}
