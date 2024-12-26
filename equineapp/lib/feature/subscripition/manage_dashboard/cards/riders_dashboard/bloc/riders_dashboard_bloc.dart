import 'package:bloc/bloc.dart';
import '../../../../../../data/repo/repo.dart';
import '../../../../../../data/service/service.dart';
import 'riders_dashboard_event.dart';
import 'riders_dashboard_state.dart';
class RidersBloc extends Bloc<RidersEvent, RidersState> {
  RidersBloc() : super(RidersLoading()) {
    on<LoadRiders>((event, emit) async {
      try {

        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final riders = await riderrepo.getAllRider();
      //   final riders = [
      //  "Antico Oriente","Antico Oriente","Antico Oriente"
      //   ];
        emit(RidersLoaded(riders:riders));
      } catch (e) {
        emit(RidersError("Failed to load riders"));
      }
    });
    // Handle the DeleteHorse event
    on<DeleteRider>((event, emit) async {
      try {
        // Call the delete API
        await riderrepo.deleteRiderById(id:event.riderId);

        // Reload the horses after deletion
        final horses = await riderrepo.getAllRider();
        emit(RidersLoaded(riders: horses));
      } catch (e) {
        emit(RidersError("Failed to delete horse"));
      }
    });
  }
}
