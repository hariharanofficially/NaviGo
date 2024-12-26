part of 'plangraph_bloc.dart';

sealed class PlangraphEvent extends Equatable {
  const PlangraphEvent();

  @override
  List<Object> get props => [];
}
class LoadPlangraph extends PlangraphEvent {
  // You can add parameters if needed for data filtering
}