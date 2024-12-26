part of 'owner_bloc.dart';

abstract class AddOwnerEvent extends Equatable {
  const AddOwnerEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends AddOwnerEvent {
  final int? id;
  final String name;
  const SubmitForm({
    this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        name,
      ];
}

class LoadOwnerbyId extends AddOwnerEvent {
  final int id;
  const LoadOwnerbyId({required this.id});
  @override
  List<Object> get props => [];
}
class PickImage extends AddOwnerEvent {}
