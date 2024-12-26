part of 'tracker_steps_bloc.dart';

abstract class TrackerStepsEvent extends Equatable {
  const TrackerStepsEvent();
  @override
  List<Object> get props => [];
}

class TrackerStepsInitialEvent extends TrackerStepsEvent {}

class TrackerStepsBluetoothEnabledEvent extends TrackerStepsEvent {}

class TrackerStepsBluetoothDisabledEvent extends TrackerStepsEvent {}

class TrackerStepsRegisteredDevicesUpdatedEvent extends TrackerStepsEvent {
  final List<RegisteredDevice> registeredDevices;
  const TrackerStepsRegisteredDevicesUpdatedEvent(
      {required this.registeredDevices});
}

class TrackerStepsPairDeviceEvent extends TrackerStepsEvent {
  final String hrCensorId;
  const TrackerStepsPairDeviceEvent({required this.hrCensorId});
}

class TrackerStepsUnPairDeviceEvent extends TrackerStepsEvent {
  final String hrCensorId;
  const TrackerStepsUnPairDeviceEvent({required this.hrCensorId});
}

class TrackerStepsPairingEvent extends TrackerStepsEvent {}

class TrackerStepsPairedEvent extends TrackerStepsEvent {}

class TrackerStepsUnPairedEvent extends TrackerStepsEvent {
  final List<RegisteredDevice> registeredDevices;
  final bool isPaired;
  TrackerStepsUnPairedEvent(
      {required this.registeredDevices, required this.isPaired});
}

class TrackerStepsBatteryValueUpdatedEvent extends TrackerStepsEvent {
  final int batteryLevel;
  const TrackerStepsBatteryValueUpdatedEvent({required this.batteryLevel});
}

class TrackerStepsEnableGpsEvent extends TrackerStepsEvent {}

class TrackerStepsRegisterDeviceButtonEvent extends TrackerStepsEvent {}

// ignore: must_be_immutable
class TrackerStepsRegisterDeviceEvent extends TrackerStepsEvent {
  String name;
  String macId;
  String deviceId;
  TrackerStepsRegisterDeviceEvent(
      {required this.name, required this.macId, required this.deviceId});
}
