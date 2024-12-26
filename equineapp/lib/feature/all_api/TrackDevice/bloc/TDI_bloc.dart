// track_device_info_bloc.dart
import 'package:EquineApp/feature/all_api/TrackDevice/bloc/TDI_event.dart';
import 'package:EquineApp/feature/all_api/TrackDevice/bloc/TDI_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TrackDeviceInfoBloc extends Bloc<TrackDeviceInfoEvent, TrackDeviceInfoState> {
  TrackDeviceInfoBloc() : super(TrackDeviceInfoInitial());

  @override
  Stream<TrackDeviceInfoState> mapEventToState(TrackDeviceInfoEvent event) async* {
    if (event is SubmitForm) {
      yield TrackDeviceInfoLoading();
      try {
        // Simulate a network request
        await Future.delayed(Duration(seconds: 2));
        yield TrackDeviceInfoSuccess();
      } catch (e) {
        yield TrackDeviceInfoFailure('Failed to add tracker information');
      }
    }
  }
}
