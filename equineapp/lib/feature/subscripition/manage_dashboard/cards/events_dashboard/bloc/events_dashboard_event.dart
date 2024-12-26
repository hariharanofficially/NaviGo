import 'package:equatable/equatable.dart';

abstract class EventsDashboardEvent extends Equatable {
  const EventsDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventsDashboardEvent {}

class DeleteEvents extends EventsDashboardEvent {
  final int eventsId;

  DeleteEvents({required this.eventsId});
}