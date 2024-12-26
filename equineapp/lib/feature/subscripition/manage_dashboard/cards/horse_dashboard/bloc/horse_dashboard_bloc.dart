import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import '../../../../../../data/service/service.dart';
import 'horse_dashboard_event.dart';
import 'horse_dashboard_state.dart';

class HorseDashboardBloc extends Bloc<HorseDashboardEvent, HorseDashboardState> {
  HorseDashboardBloc() : super(HorsesLoading()) {
    on<LoadHorses>((event, emit) async {
      try {
        
        // final String id = event.id;
        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final horses = await horseRepo.getAllHorses(tenantId: tenantId);
        //final horses = ["Antico Oriente", "Antico Oriente", "Antico Oriente"]; // Replace with actual data fetching logic
        emit(HorsesLoaded(horses:horses));
      } catch (e) {
        emit(HorsesError("Failed to load horses"));
      }
    });
    // Handle the DeleteHorse event
    on<DeleteHorse>((event, emit) async {
      try {
        // Call the delete API
        await horseRepo.deleteHorsesById(id:event.horseId);

        // Reload the horses after deletion
        var tenantId = await cacheService.getString(name: 'tenantId');
        final horses = await horseRepo.getAllHorses(tenantId: tenantId);
        emit(HorsesLoaded(horses: horses));
      } catch (e) {
        emit(HorsesError("Failed to delete horse"));
      }
    });
  }
}
