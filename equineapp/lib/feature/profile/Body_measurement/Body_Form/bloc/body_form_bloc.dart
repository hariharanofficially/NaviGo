import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/body_model.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/repo/repo.dart';

part 'body_form_event.dart';
part 'body_form_state.dart';

class BodyFormBloc extends Bloc<BodyFormEvent, BodyFormState> {
  Logger logger = new Logger();

  BodyFormBloc() : super(BodyFormInitial()) {
    on<SubmitBodyMeasurement>((event, emit) async {
      emit(BodyFormLoading());
      try {
        final response = event.id != null
            ? await bodymeasurementrepo.updateBodyMeasurement(
                horseId: event.horse.id,
                dateOfBirth: event.dateOfBirth,
                weight: event.weight,
                id: event.id!,
              )
            : await bodymeasurementrepo.AddBodyMeasurement(
                horseId: event.horse.id,
                dateOfBirth: event.dateOfBirth,
                weight: event.weight,
              );
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(AddBodymeasurementSuccess(message: response.message));
        } else {
          emit(AddBodymeasurementFailure(error: response.message));
        }
      } catch (e) {
        emit(AddBodymeasurementFailure(error: e.toString()));
      }
    });
    on<LoadBodyformByid>((event, emit) async {
      emit(BodyFormLoading());
      try {
        BodyModel body =
            await bodymeasurementrepo.getAllBodyMeasurementById(id: event.id);
        emit(BodyFormLoaded(body: body));
      } catch (e) {
        emit(BodyFormerror(error: e.toString()));
      }
    });
  }
}
