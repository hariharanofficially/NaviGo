import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';

part 'init_event.dart';
part 'init_state.dart';
// BLoC
class InitBloc extends Bloc<InitEvent, InitState> {
  InitBloc() : super(InitInitial()) {
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<InitState> emit,
  ) async {
    emit(InitLoading());
    try {
      bool isLoggedIn = await cacheRepo.getBoolean(name: "isLoggedIn");
      var tenant = await cacheService.getString(name: 'tenantId');
      var planId = await cacheService.getString(name: 'planId');

      if (isLoggedIn) {
        if (planId == null || planId == '') {
          emit(InitSuccess(RoutePath.plan));
        } else {
          if (planId == '1') {
            emit(InitSuccess(RoutePath.eventorganizerdashboard));
          } else {
            emit(InitSuccess(RoutePath.singlestabledashboard));
          }
        }
      } else {
        emit(InitSuccess(RoutePath.signin));
      }
    } catch (e) {
      emit(InitFailure('An error occurred'));
    }
  }
}