part of 'init_bloc.dart';

// State
abstract class InitState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitInitial extends InitState {}

class InitLoading extends InitState {}

class InitSuccess extends InitState {
  final String route;

  InitSuccess(this.route);

  @override
  List<Object> get props => [route];
}

class InitFailure extends InitState {
  final String message;

  InitFailure(this.message);

  @override
  List<Object> get props => [message];
}
