part of 'event_menu_bloc.dart';

class EventMenuState extends Equatable{
  @override
   List<Object> get props => [];
}

class EventMenuInitial extends EventMenuState{}

class EventMenuSelectedTab extends EventMenuState{
  final int tabIndex;
  EventMenuSelectedTab(this.tabIndex);
  @override
  List<Object> get props => [tabIndex];
}