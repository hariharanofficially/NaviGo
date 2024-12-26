part of 'owner_bloc.dart';

abstract class OwnerEvent extends Equatable {
  const OwnerEvent();

  @override
  List<Object> get props => [];
}

class LoadOwner extends OwnerEvent {}

class DeleteOwner extends OwnerEvent {
  final int ownerId;

  DeleteOwner({required this.ownerId});
}
