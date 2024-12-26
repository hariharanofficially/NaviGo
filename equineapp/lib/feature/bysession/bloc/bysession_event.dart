part of 'bysession_bloc.dart';

abstract class Bysessionevent extends Equatable {
  const Bysessionevent();

  @override
  List<Object> get props => [];
}

// Event to load initial sessions
class LoadSessionsEvent extends Bysessionevent {}

class Traningcreated extends Bysessionevent {}

class Deletebysession extends Bysessionevent {
  final int eventsId;

  Deletebysession({required this.eventsId});
}
