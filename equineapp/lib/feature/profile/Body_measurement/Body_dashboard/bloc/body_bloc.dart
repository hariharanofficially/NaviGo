import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/body_model.dart';
import '../../../../../data/service/service.dart';

part 'body_event.dart';
part 'body_state.dart';

class BodyBloc extends Bloc<BodyEvent, BodyState> {
  BodyBloc() : super(BodyLoading()) {
    on<LoadBody>((event, emit) async {
      try {
        final Body = await bodymeasurementrepo.getAllBodyMeasurement();
        // final Body = [
        //   "Weight",
        //   "Height",
        // ];
        emit(BodyLoaded(Body: Body));
      } catch (e) {
        emit(BodyError("Failed to load horses"));
      }
    });
    on<DeleteBody>((event, emit) async {
      try {
        // Call the delete API
        await bodymeasurementrepo.deletebodymeasurement(id: event.bodyId);

        // Reload the horses after deletion
        // final Body = await bodymeasurementrepo.getAllBodyMeasurement();
        emit(BodyDeleted());
      } catch (e) {
        emit(BodyDeleted());
      }
    });
  }
}
