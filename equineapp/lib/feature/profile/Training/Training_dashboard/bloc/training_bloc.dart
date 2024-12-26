import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/training_model.dart';

part 'training_event.dart';
part 'training_state.dart';

class TraningBloc extends Bloc<TraningEvent, TraningState> {
  TraningBloc() : super(TraningLoading()) {
    on<LoadTraning>((event, emit) async {
      try {
        // Assuming `trainingDatetime` is your DateTime object

        // Fetch the training data
        final List<TrainingModel> trainings =
            await trainingrepo.getAllTraining();
// Convert fetched training data into the format required by TraningLoaded
        final traningData = trainings.map((training) {
          String formattedDate =
              DateFormat('dd-MMM-yy').format(training.trainingDatetime);
          return {
            "Traning":
                training.trainingTypeName ?? 'Unknown', // Ensure non-null
            "Traning2": training.duration, // String value, can be null
            "Traning3": "${training.distance} km", // String value, can be null
            "Traning4": training.walk ?? '', // Provide a default if null
            "Traning5": training.trot ?? '', // Provide a default if null
            "Traning6": training.canter ?? '', // Provide a default if null
            "Traning7": training.gallop ?? '', // Provide a default if null
            "datetime": formattedDate ?? '', // Provide a default if null
            "treatmentId": training.id.toString(),
          } as Map<String, Object>; // Cast to Map<String, Object>
        }).toList();
        // final Traning = [
        //   {
        //     "Traning": "Barrel Racing",
        //     "Traning2": "30m 0s",
        //     "Traning3": "50.5K km/h",
        //     "Traning4": "30m 0s",
        //     "Traning5": "30m 0s",
        //     "Traning6": "30m 0s",
        //     "Traning7": "30m 0s",
        //   },
        // ];
        emit(TraningLoaded(Traning: traningData));
      } catch (e) {
        emit(TraningError("Failed to load Traning"));
      }
    });
    on<DeleteTraining>((event, emit) async {
      try {
        // Call the delete API for training
        await trainingrepo.deletetraining(id: event.trainingId);

        // Reload training data after deletion
        // final List<TrainingModel> trainings =
        //     await trainingrepo.getAllTraining();

        // // Format the data again for the TraningLoaded state
        // final traningData = trainings.map((training) {
        //   String formattedDate =
        //       DateFormat('d\'th\' MMMM').format(training.trainingDatetime);
        //   return {
        //     "Traning":
        //         training.trainingTypeName ?? 'Unknown', // Ensure non-null
        //     "Traning2": training.duration ?? 'N/A',
        //     "Traning3":
        //         training.distance != null ? "${training.distance} km" : 'N/A',
        //     "Traning4": training.walk ?? 'N/A',
        //     "Traning5": training.trot ?? 'N/A',
        //     "Traning6": training.canter ?? 'N/A',
        //     "Traning7": training.gallop ?? 'N/A',
        //     "datetime": formattedDate, "treatmentId": training.id.toString(),
        //   };
        // }).toList();

        emit(TrainingDeleted());
      } catch (e) {
        emit(TrainingDeleted());
      }
    });
  }
}
