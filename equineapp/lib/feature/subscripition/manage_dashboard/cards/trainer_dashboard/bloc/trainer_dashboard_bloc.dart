import 'package:bloc/bloc.dart';
import '../../../../../../data/repo/repo.dart';
import '../../../../../../data/service/service.dart';
import 'trainer_dashboard_event.dart';
import 'trainer_dashboard_state.dart';

class TrainersBloc extends Bloc<TrainersEvent, TrainersState> {
  TrainersBloc() : super(TrainersLoading()) {
    on<LoadTrainers>((event, emit) async {
      try {

        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final Trainers = await trainerrepo.getAllTrainer();
      //   final Trainers = [
      //  "Antico Oriente","Antico Oriente","Antico Oriente"
      //   ];
        emit(TrainersLoaded(Trainers:Trainers));
      } catch (e) {
        emit(TrainersError("Failed to load Trainers"));
      }
    });
    // Handle the DeleteHorse event
    on<DeleteTrainer>((event, emit) async {
      try {
        // Call the delete API
        await trainerrepo.deleteTrainerById(id:event.TrainerId);

        // Reload the horses after deletion
        final horses = await trainerrepo.getAllTrainer();
        emit(TrainersLoaded(Trainers: horses));
      } catch (e) {
        emit(TrainersError("Failed to delete horse"));
      }
    });
  }
}
