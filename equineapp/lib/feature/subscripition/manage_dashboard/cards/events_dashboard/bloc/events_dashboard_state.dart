import 'package:equatable/equatable.dart';

import '../../../../../../data/models/event_model.dart';
import '../../../../../../data/models/events.dart';

abstract class EventsDashboardState extends Equatable {
  const EventsDashboardState();

  @override
  List<Object> get props => [];
}


class EventsLoading extends EventsDashboardState {}

class EventsLoaded extends EventsDashboardState {
  final List<EventModel> events; // Replace with your actual event model

  const EventsLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventsError extends EventsDashboardState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object> get props => [message];
}
