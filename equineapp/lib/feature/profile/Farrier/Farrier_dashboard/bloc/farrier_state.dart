part of 'farrier_bloc.dart';

sealed class FarrierState extends Equatable {
  const FarrierState();

  @override
  List<Object> get props => [];
}

class FarrierLoading extends FarrierState {}

class FarrierLoaded extends FarrierState {
  final List<Map<String, Object>> Farrier;

  const FarrierLoaded({required this.Farrier});
  @override
  List<Object> get props => [Farrier];
}

class FarrierError extends FarrierState {
  final String message;

  const FarrierError(this.message);
  @override
  List<Object> get props => [message];
}
class FarrierDeleted extends FarrierState {}