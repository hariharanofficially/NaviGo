import 'package:equatable/equatable.dart';
// Events
abstract class SingleStableMenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectTabEvent extends SingleStableMenuEvent {
  final int tabIndex;

  SelectTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}