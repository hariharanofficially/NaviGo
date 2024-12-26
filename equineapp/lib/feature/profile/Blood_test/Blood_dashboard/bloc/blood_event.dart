part of 'blood_bloc.dart';

sealed class BloodEvent extends Equatable {
  const BloodEvent();

  @override
  List<Object> get props => [];
}
class LoadBlood extends BloodEvent {
  final String horseId;
  // final String id;
  const LoadBlood({
  required this.horseId});
  @override
  List<Object> get props => [];
}

class DeleteBloodTest extends BloodEvent {
  final String id;
  // final String id;
  const DeleteBloodTest({
    required this.id});
  @override
  List<Object> get props => [];
}