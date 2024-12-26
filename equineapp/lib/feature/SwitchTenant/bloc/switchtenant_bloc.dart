import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/tenant_model.dart';
import '../../../data/models/usertenant_model.dart';
import '../../../data/service/service.dart';

part 'switchtenant_event.dart';
part 'switchtenant_state.dart';

class SwitchtenantBloc extends Bloc<SwitchtenantEvent, SwitchtenantState> {
  SwitchtenantBloc() : super(SwitchLoading()) {
    on<LoadSwitch>((event, emit) async {
      try {
        // Replace with actual data fetching logic
        var userId = await cacheService.getString(name: 'userId');
        var tenantId = await cacheService.getString(name: 'tenantId');
        print('userId');
        print(userId);
        final switchtenant = await tenantrepo.getTenantbyid(id: userId);
        print('Fetched tenants: $switchtenant');
        //final Switch = ["Antico Oriente", "Antico Oriente", "Antico Oriente"];
        emit(SwitchLoaded(Switch: switchtenant, tenantId: tenantId));
      } catch (e) {
        emit(SwitchError("Failed to Switch tenant"));
      }
    });

    on<SwitchTenant>((event, emit) async {
      try {
        // Replace with actual data fetching logic
        cacheService.setString(name: 'tenantId', value: event.id);
        emit(SwitchedTenant());
      } catch (e) {
        emit(SwitchError("Failed to Switch tenant"));
      }
    });
  }
}
