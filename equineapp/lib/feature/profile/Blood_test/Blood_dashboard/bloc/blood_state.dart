part of 'blood_bloc.dart';

sealed class BloodState extends Equatable {
  const BloodState();

  @override
  List<Object> get props => [];
}

class BloodLoading extends BloodState {}

class BloodLoaded extends BloodState {
  final List<BloodTestResult> blood;

  const BloodLoaded({required this.blood});

  @override
  List<Object> get props => [blood];
}

class BloodError extends BloodState {
  final String message;

  const BloodError(this.message);

  @override
  List<Object> get props => [message];
}

class BloodTestDeleted extends BloodState {}