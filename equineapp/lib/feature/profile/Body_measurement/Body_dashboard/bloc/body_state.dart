part of 'body_bloc.dart';

sealed class BodyState extends Equatable {
  const BodyState();

  @override
  List<Object> get props => [];
}

final class BodyLoading extends BodyState {}

class BodyLoaded extends BodyState {
  final List<BodyModel> Body;

  const BodyLoaded({required this.Body});

  @override
  List<Object> get props => [Body];
}

class BodyError extends BodyState {
  final String message;

  const BodyError(this.message);

  @override
  List<Object> get props => [message];
}
class BodyDeleted extends BodyState {}