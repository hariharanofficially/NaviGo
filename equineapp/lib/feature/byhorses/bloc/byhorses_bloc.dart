import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';
import 'package:EquineApp/data/models/horse_model.dart';

part 'byhorses_event.dart';
part 'byhorses_state.dart';

class byhorsesbloc extends Bloc<byhorsesevent, byhorsesState> {
  byhorsesbloc() : super(ByHorsesLoading()) {
    on<LoadByHorses>((event, emit) async {
      try {
        var tenantId = await cacheService.getString(name: 'tenantId');
        final horses = await horseRepo.getAllHorses(tenantId: tenantId);
        // final horse = [
        //   "Antico Oriente",
        //   "Antico Oriente",
        //   "Antico Oriente"
        // ]; // Replace with actual data fetching logic
        emit(ByHorsesLoaded(horses: horses));
      } catch (e) {
        emit(ByHorsesError("Failed to load horses"));
      }
    });
  }
}
