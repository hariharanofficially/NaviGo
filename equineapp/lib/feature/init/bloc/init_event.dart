part of 'init_bloc.dart';

// Event
abstract class InitEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckLoginStatus extends InitEvent {}