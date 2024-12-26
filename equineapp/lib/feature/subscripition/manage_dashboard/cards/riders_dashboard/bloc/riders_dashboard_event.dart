import 'package:equatable/equatable.dart';

abstract class RidersEvent extends Equatable {
  const RidersEvent();

  @override
  List<Object> get props => [];
}

class LoadRiders extends RidersEvent {}


class DeleteRider extends RidersEvent {
  final int riderId;

  DeleteRider({required this.riderId});
}
