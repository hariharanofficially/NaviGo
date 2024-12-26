part of 'plangraph_bloc.dart';

sealed class PlangraphState extends Equatable {
  const PlangraphState();

  @override
  List<Object> get props => [];
}


class PlangraphLoading extends PlangraphState {}

class PlangraphLoaded extends PlangraphState {
  final List<FlSpot> graphData; // Add this field to hold graph data

  PlangraphLoaded({required this.graphData});
}

class PlangraphError extends PlangraphState {}
