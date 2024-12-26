import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../../data/models/registered_device_model.dart';

part 'mydevices_form_event.dart';

part 'mydevices_form_state.dart';

class MydevicesFormBloc extends Bloc<MydevicesFormEvent, MydevicesFormState> {
  Logger logger = Logger();

  MydevicesFormBloc() : super(MydevicesFormInitial()) {
    on<submitdevice>(_Submitdevice);
    on<Loadmydevices>(_Loadmydevices);
  }

  void _Submitdevice(
      submitdevice event, Emitter<MydevicesFormState> emit) async {
    emit(MydevicesFormSubmitting());
    try {
      logger.d("performing ${event.id != null ? 'update' : 'add'} horse");

      final response = event.id != null
          ? await trackerRepo.updatetrackerdevices(
              id: event.id!,
              deviceName: event.devicename,
              macId: event.macId,
              deviceId: event.deviceId)
          : await trackerRepo.addtrackerdevices(
              deviceName: event.devicename,
              macId: event.macId,
              deviceId: event.deviceId);
      // Now, log the response
      logger.d(response.data);
      if (response.statusCode == 200 && response.error.isEmpty) {
        emit(MydevicesFormSubmittedSuccessfully(message: response.message));
      } else {
        emit(MydevicesFormSubmittedFailure(error: response.message));
      }
    } catch (e) {
      emit(MydevicesFormSubmittedFailure(error: e.toString()));
    }
  }

  void _Loadmydevices(
      Loadmydevices event, Emitter<MydevicesFormState> emit) async {
    emit(MydevicesFormLoading());
    try {

      final Mydevice =
          await trackerRepo.getAlltrackerdeviceById(id: event.mydevices);
      // Now, log the response
      logger.d('response.data');
      logger.d(Mydevice);
      emit(MydevicesformLoaded(device: Mydevice));
    } catch (e) {
      emit(MydevicesFormerror(message: e.toString()));
    }
  }
}
