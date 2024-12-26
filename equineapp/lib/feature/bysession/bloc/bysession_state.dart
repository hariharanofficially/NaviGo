part of 'bysession_bloc.dart';

abstract class Bysessionstate extends Equatable {
  const Bysessionstate();

  @override
  List<Object> get props => [];
}

class BysessionLoading extends Bysessionstate {}

class BysessionLoaded extends Bysessionstate {
  final List<EventModel> sessions; // List to hold multiple sessions

  const BysessionLoaded({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class Bysessionerror extends Bysessionstate {
  final String message;

  const Bysessionerror(this.message);

  @override
  List<Object> get props => [message];
}

class TraningSubmitting extends Bysessionstate {}

class TraningSubmittedSuccessfully extends Bysessionstate {
  final String message;
  const TraningSubmittedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}

class TraningSubmittedFailure extends Bysessionstate {
  final String error;
  const TraningSubmittedFailure({required this.error});

  @override
  List<Object> get props => [error];
}
