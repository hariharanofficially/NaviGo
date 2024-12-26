import 'package:EquineApp/data/repo/repo.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_event.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_state.dart';
import 'package:bloc/bloc.dart';

import '../../../../../../data/service/service.dart';

class StableBloc extends Bloc<StableEvent, StableState> {
  StableBloc() : super(StableLoading()) {
    on<LoadStable>((event, emit) async {
      try {
        // Simulate a network call
        //await Future.delayed(Duration(seconds: 2));
        var tenantId = await cacheService.getString(name: 'tenantId');
        final Stable = await stablerepo.getAllStable(tenantId);
        print('Fetched Stable: $Stable');
        emit(StableLoaded(stables: Stable));
      } catch (e) {
        emit(StableError("Failed to load stable"));
      }
    }); // Handle the DeleteHorse event
    on<DeleteStable>((event, emit) async {
      try {
        // Call the delete API
        await stablerepo.deleteStableById(id: event.stableId);

        // Reload the horses after deletion
        var tenantId = await cacheService.getString(name: 'tenantId');
        final Stable = await stablerepo.getAllStable(tenantId);
        emit(StableLoaded(stables: Stable));
      } catch (e) {
        emit(StableError("Failed to delete horse"));
      }
    });
  }
}
