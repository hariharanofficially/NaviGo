import 'package:EquineApp/data/models/stable_model.dart';
import 'package:equatable/equatable.dart';

abstract class StableState extends Equatable {
  const StableState();

  @override
  List<Object> get props => [];
}


class StableLoading extends StableState {}


class StableLoaded extends StableState {
  final List<StableModel> stables;
  //final List<String >stables; // Replace with actual participant model

  const StableLoaded({
    required this.stables});

  @override
  List<Object> get props => [stables];
}

class StableError extends StableState {
  final String message;

  const StableError(this.message);

  @override
  List<Object> get props => [message];
}
