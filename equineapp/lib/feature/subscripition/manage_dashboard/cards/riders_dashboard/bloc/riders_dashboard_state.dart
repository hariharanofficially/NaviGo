import 'package:equatable/equatable.dart';

import '../../../../../../data/models/rider_model.dart';

abstract class RidersState extends Equatable {
  const RidersState();

  @override
  List<Object> get props => [];
}

class RidersLoading extends RidersState {}

class RidersLoaded extends RidersState {
  final List<RiderModel> riders;

  const RidersLoaded({required this.riders});

  @override
  List<Object> get props => [riders];
}

class RidersError extends RidersState {
  final String message;

  const RidersError(this.message);

  @override
  List<Object> get props => [message];
}