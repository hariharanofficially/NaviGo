part of 'farrier_bloc.dart';

sealed class FarrierEvent extends Equatable {
  const FarrierEvent();

  @override
  List<Object> get props => [];
}

class LoadFarrier extends FarrierEvent {
  // final String id;
  const LoadFarrier();
  @override
  List<Object> get props => [];
}
class DeleteFarrier extends FarrierEvent {
  final int farrierId;

  DeleteFarrier({required this.farrierId});
}
