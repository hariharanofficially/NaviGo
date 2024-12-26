import 'package:bloc/bloc.dart';

import 'Profiling_event.dart';
import 'Profiling_state.dart';

class ProfilingBloc extends Bloc<ProfilingEvent, ProfilingState> {
  ProfilingBloc() : super(ProfilingInitial()) {
    on<ProfilingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
