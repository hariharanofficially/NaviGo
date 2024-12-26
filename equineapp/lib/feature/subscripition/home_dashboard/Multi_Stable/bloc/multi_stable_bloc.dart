import 'dart:async';

import 'package:EquineApp/feature/subscripition/home_dashboard/Multi_Stable/bloc/multi_stable_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiStableDashboardBloc extends Cubit<int> {
  final _eventController = StreamController<MultiStableDashboardEvent>();
  Stream<MultiStableDashboardEvent> get events => _eventController.stream;

  final _stateController = StreamController<int>();
  Stream<int> get selectedTabIndex => _stateController.stream;

  MultiStableDashboardBloc(): super(0)  {
    _eventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  void _mapEventToState(MultiStableDashboardEvent event) {
    switch (event) {
      case MultiStableDashboardEvent.loadInitialData:
        // Implement loading initial data logic here
        break;
      case MultiStableDashboardEvent.navigateToTrackDevice:
        // Implement navigation logic here
        break;
    }
  }

  void setSelectedTab(int index) {
    _stateController.sink.add(index);
  }

  void emitEvent(MultiStableDashboardEvent event) {
    _eventController.sink.add(event);
  }
}