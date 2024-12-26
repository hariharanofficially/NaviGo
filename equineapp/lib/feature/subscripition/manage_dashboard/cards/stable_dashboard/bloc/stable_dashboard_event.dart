import 'package:equatable/equatable.dart';

abstract class StableEvent extends Equatable {
  const StableEvent();

  @override
  List<Object> get props => [];
}

class LoadStable extends StableEvent {}

class DeleteStable extends StableEvent {
  final int stableId;

  DeleteStable({required this.stableId});
}
