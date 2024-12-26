// track_device_info_event.dart
import 'package:equatable/equatable.dart';

abstract class TrackDeviceInfoEvent extends Equatable {
  const TrackDeviceInfoEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends TrackDeviceInfoEvent {}
