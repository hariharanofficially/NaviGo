import 'package:equatable/equatable.dart';
// States
abstract class SingleStableMenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class SingleStableMenuInitial extends SingleStableMenuState {}

class SingleStableMenuSelectedTab extends SingleStableMenuState {
  final int tabIndex;

  SingleStableMenuSelectedTab(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
