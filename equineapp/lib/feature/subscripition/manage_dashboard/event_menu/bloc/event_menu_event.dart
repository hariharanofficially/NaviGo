part of 'event_menu_bloc.dart';


abstract class EventMenuEvent extends Equatable{
  @override 
  List<Object> get props =>[];
}
class SelectTabEventMenu extends EventMenuEvent{
  final int tabindex;
  SelectTabEventMenu(this.tabindex);
  @override
  List<Object> get props =>[tabindex];
}