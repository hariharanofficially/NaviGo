import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/surfaceType.dart';
import '../../../../../data/models/trainingType.dart';
import '../../../../../data/models/training_model.dart';
import '../../../../../data/repo/repo.dart';
part 'training_form_event.dart';
part 'training_form_state.dart';

class TraningFormBloc extends Bloc<TraningFormEvent, TraningFormState> {
  Logger logger = new Logger();
  TraningFormBloc() : super(TraningFormInitial()) {
    on<SubmitFormTraining>((event, emit) async {
      try {
        String datetime = event.trainingDatetime + "T00:00:00";
        String duration = event.duration;
        logger.d(duration);
        final response = event.id != null
            ? await trainingrepo.updateTraining(
                id: event.id!,
                trainingDatetime: datetime,
                horseId: event.horseId,
                stableId: event.stableId,
                riderId: event.riderId,
                trainingId: event.trainingId,
                surfaceId: event.surfaceId,
                distance: event.distance,
                duration: event.duration,
                walk: event.walk,
                trot: event.trot,
                canter: event.canter,
                gallop: event.gallop,
              )
            : await trainingrepo.addTraining(
                trainingDatetime: datetime,
                horseId: event.horseId,
                stableId: event.stableId,
                riderId: event.riderId,
                trainingId: event.trainingId,
                surfaceId: event.surfaceId,
                distance: event.distance,
                duration: event.duration,
                walk: event.walk,
                trot: event.trot,
                canter: event.canter,
                gallop: event.gallop);
        logger.d(response.data);
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(TraningFormSuccessfully(message: response.message));
        } else {
          emit(TraningFormFailure(error: response.message));
        }
      } catch (e) {
        emit(TraningFormFailure(error: e.toString()));
      }
    });
    on<LoadFetchtraining>((event, emit) async {
      emit(TrainingLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(TrainingLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Trainingerror(message: e.toString()));
      }
    });
    on<LoadFetchtrainingByid>((event, emit) async {
      emit(TrainingLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        TrainingModel training =
            await trainingrepo.getAllTrainingById(id: event.id);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.trainingDetail = training;
        emit(TrainingLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Trainingerror(message: e.toString()));
      }
    });
    on<SubmitTrainingType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateTrainingType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addTrainingType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<TrainingType> types = await masterApiRepo.getAllTrainingTypes();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(TrainingTypeCreateSuccess(types: types));
        } else {
          emit(TrainingTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(TrainingTypeCreateFailed(error: e.toString()));
      }
    });
    on<DeleteTrainingType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteTrainingTypes(id: event.trainingtypeId);

        List<TrainingType> types = await masterApiRepo.getAllTrainingTypes();

        emit(TrainingTypeDeleted(types: types));
      } catch (e) {
        emit(TraningFormFailure(error: e.toString()));
      }
    });
    on<SubmitSurfaceType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateSurfaceType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addSurfaceType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<SurfaceType> types = await masterApiRepo.getAllSurfaceTypes();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(SurfaceTypeCreateSuccess(types: types));
        } else {
          emit(SurfaceTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(SurfaceTypeCreateFailed(error: e.toString()));
      }
    });
    on<DeleteSurfaceType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteSurfaceTypes(id: event.surfacetypeId);

        List<SurfaceType> types = await masterApiRepo.getAllSurfaceTypes();

        emit(SurfaceTypeDeleted(types: types));
      } catch (e) {
        emit(TraningFormFailure(error: e.toString()));
      }
    });
  }
}
