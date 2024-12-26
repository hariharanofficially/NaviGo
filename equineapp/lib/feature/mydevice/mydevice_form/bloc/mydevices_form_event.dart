part of 'mydevices_form_bloc.dart';

abstract class MydevicesFormEvent extends Equatable {
  const MydevicesFormEvent();

  @override
  List<Object> get props => [];
}

class submitdevice extends MydevicesFormEvent {
  final int? id;
  final String devicename;
  final String macId;
  final String deviceId;

  submitdevice({
    this.id,
    required this.devicename,
    required this.macId,
    required this.deviceId,
  });
}

class Loadmydevices extends MydevicesFormEvent {
  final int mydevices;

  // final XFile? imageFile;
  const Loadmydevices({
    required this.mydevices,
    // this.imageFile,
  });
}
