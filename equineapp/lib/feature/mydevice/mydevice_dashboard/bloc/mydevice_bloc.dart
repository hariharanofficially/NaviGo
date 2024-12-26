import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/registered_device_model.dart';
import '../../../../data/models/tracker_device_model.dart';

part'mydevice_event.dart';
part 'mydevice_state.dart';

class MydeviceBloc extends Bloc<MydeviceEvent, MydeviceState> {
  MydeviceBloc() : super(MydeviceLoading()) {
    on<LoadMydevice>((event, emit) async {
      try {
        final Mydevice = await trackerRepo.getAlltrackerdevice();
        // final Mydevice = ["Antico Oriente", "Antico Oriente", "Antico Oriente"];
        emit(MydeviceLoaded(Mydevice: Mydevice));
      } catch (e) {
        emit(MydeviceError("Failed to load Mydevic"));
      }
    });
  }
}
