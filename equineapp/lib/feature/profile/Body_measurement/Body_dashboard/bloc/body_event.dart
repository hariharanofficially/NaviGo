part of 'body_bloc.dart';

sealed class BodyEvent extends Equatable {
  const BodyEvent();

  @override
  List<Object> get props => [];
}

class LoadBody extends BodyEvent {
  // final String id;
  const LoadBody();
  @override
  List<Object> get props => [];
}

class DeleteBody extends BodyEvent {
  final int bodyId;

  DeleteBody({required this.bodyId});
}
