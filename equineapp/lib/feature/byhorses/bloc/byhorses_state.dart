
part of'byhorses_bloc.dart';


abstract class byhorsesState extends Equatable {
  const byhorsesState();

  @override
  List<Object> get props => [];
}

class ByHorsesLoading extends byhorsesState {}

class ByHorsesLoaded extends byhorsesState {
  final List<HorseModel> horses;

  const ByHorsesLoaded({required this.horses});

  @override
  List<Object> get props => [horses];
}

class ByHorsesError extends byhorsesState {
  final String message;

  const ByHorsesError(this.message);

  @override
  List<Object> get props => [message];
}
