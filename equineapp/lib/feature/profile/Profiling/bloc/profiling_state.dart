import 'package:equatable/equatable.dart';

sealed class ProfilingState extends Equatable {
  const ProfilingState();

  @override
  List<Object> get props => [];
}

class ProfilingInitial extends ProfilingState {}

