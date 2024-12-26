part of 'mydevice_bloc.dart';
sealed class MydeviceState extends Equatable {
  const MydeviceState();

  @override
  List<Object> get props => [];
}

class MydeviceLoading extends MydeviceState {}

class MydeviceLoaded extends MydeviceState {
  final List<RegisteredDevice> Mydevice;
  //final List<String >stables; // Replace with actual participant model

  const MydeviceLoaded({required this.Mydevice});

  @override
  List<Object> get props => [Mydevice];
}

class MydeviceError extends MydeviceState {
  final String message;

  const MydeviceError(this.message);

  @override
  List<Object> get props => [message];
}
