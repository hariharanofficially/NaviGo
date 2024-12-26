part of 'tracker_steps_bloc.dart';

abstract class TrackerStepsState extends Equatable {
  const TrackerStepsState();
  @override
  List<Object> get props => [];
}

class TrackerStepsInitialState extends TrackerStepsState {
  @override
  List<Object> get props => [];
}

//Bluetooth view states
class TrackerStepBlueToothState extends TrackerStepsState {}

// ignore: must_be_immutable
class TrackerStepBluetoothViewState extends TrackerStepBlueToothState {
  List<RegisteredDevice> registeredDevices;
  RegisteredDevice connectedDevice;
  bool isPaired;
  TrackerStepBluetoothViewState(
      {required this.registeredDevices,
      required this.connectedDevice,
      required this.isPaired});
}

class TrackerStepsShowBluetoothEnableDialogState
    extends TrackerStepBlueToothState {}

// ignore: must_be_immutable
class TrackerStepsRegisteredDevicesUpdatedState
    extends TrackerStepBlueToothState {
  List<RegisteredDevice> registeredDevices;
  TrackerStepsRegisteredDevicesUpdatedState({required this.registeredDevices});
}

// ignore: must_be_immutable
class TrackerStepsBatteryValueState extends TrackerStepBlueToothState {
  int batteryLevel;
  TrackerStepsBatteryValueState({required this.batteryLevel});
}

class TrackerStepsPairingTakingTooLongState extends TrackerStepBlueToothState {}

class TrackerStepsPairingState extends TrackerStepBlueToothState {}

class TrackerStepsPairedState extends TrackerStepBlueToothState {}

// ignore: must_be_immutable
class TrackerStepsUnPairedState extends TrackerStepBlueToothState {
  List<RegisteredDevice> registeredDevices;
  bool isPaired;
  TrackerStepsUnPairedState(
      {required this.registeredDevices, required this.isPaired});
}

//Gps view States
class TrackerStepGpsState extends TrackerStepsState {}

// ignore: must_be_immutable
class TrackerStepGpsViewState extends TrackerStepGpsState {
  RegisteredDevice connectedDevice;
  TrackerStepGpsViewState({required this.connectedDevice});
}

class TrackerStepsEnabledGpsState extends TrackerStepGpsState {}

//Golive view States
class TrackerStepGoliveState extends TrackerStepsState {}

// ignore: must_be_immutable
class TrackerStepGoliveViewState extends TrackerStepGoliveState {
  RegisteredDevice connectedDevice;
  ParticipantModel? participant;
  TrackerStepGoliveViewState(
      {required this.connectedDevice, required this.participant});
}

class TrackerStepsGoLiveTriggeredState extends TrackerStepGpsState {}

// Tracker device add
class TrackerStepsRegisterDevicePopupState extends TrackerStepsState {}

class TrackerStepsAddRegisterDeviceErrorState extends TrackerStepsState {}
