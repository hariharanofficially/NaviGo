part of 'mydevice_bloc.dart';

sealed class MydeviceEvent extends Equatable {
  const MydeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadMydevice extends MydeviceEvent {}
