// add_stable_event.dart
import 'package:equatable/equatable.dart';

abstract class AddStableEvent extends Equatable {
  const AddStableEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends AddStableEvent {
  final int? id;
  final String name;
  final String address;
  final String phoneNumber;

  const SubmitForm({
    this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
  });
}

class LoadstablebyId extends AddStableEvent {
  final int id;
  const LoadstablebyId({required this.id});
  @override
  List<Object> get props => [];
}
class PickImage extends AddStableEvent {}

class UploadImage extends AddStableEvent {
  final bool isEdit; // Flag to indicate if this is an edit operation

  UploadImage({required this.isEdit});
}
