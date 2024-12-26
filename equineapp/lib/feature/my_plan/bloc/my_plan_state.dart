import 'package:equatable/equatable.dart';

abstract class myplanState extends Equatable {
  const myplanState();

  @override
  List<Object> get props => [];
}

class myplanInitial extends myplanState {}

class myplanLoading extends myplanState {}

class myplanLoaded extends myplanState {
  final String planName;
  final DateTime expiryDate;

  const myplanLoaded({required this.planName, required this.expiryDate});

  @override
  List<Object> get props => [planName, expiryDate];
}

class myplanError extends myplanState {
  final String message;

  const myplanError({required this.message});

  @override
  List<Object> get props => [message];
}
