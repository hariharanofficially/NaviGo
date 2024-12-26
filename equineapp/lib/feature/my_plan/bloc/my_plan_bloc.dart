import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_plan_event.dart';
import 'my_plan_state.dart';


class myplanBloc extends Bloc<myplanEvent, myplanState> {
  myplanBloc() : super(myplanInitial()) {
    on<Loadmyplan>((event, emit) {
      // Simulate fetching data
      emit(myplanLoading());
      Future.delayed(Duration(seconds: 2), () {
        emit(myplanLoaded(planName: 'Event Organizer', expiryDate: DateTime(2024, 6, 21)));
      });
    });

    on<Upgrademyplan>((event, emit) {
      // Simulate upgrading plan
      emit(myplanLoading());
      Future.delayed(Duration(seconds: 2), () {
        emit(myplanLoaded(planName: 'Premium Organizer', expiryDate: DateTime(2025, 6, 21)));
      });
    });
  }
}
