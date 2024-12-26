// track_device_info_state.dart
import 'package:equatable/equatable.dart';

abstract class TrackDeviceInfoState extends Equatable {
  const TrackDeviceInfoState();

  @override
  List<Object> get props => [];
}

class TrackDeviceInfoInitial extends TrackDeviceInfoState {}

class TrackDeviceInfoLoading extends TrackDeviceInfoState {}

class TrackDeviceInfoSuccess extends TrackDeviceInfoState {}

class TrackDeviceInfoFailure extends TrackDeviceInfoState {
  final String error;

  const TrackDeviceInfoFailure(this.error);

  @override
  List<Object> get props => [error];
}
