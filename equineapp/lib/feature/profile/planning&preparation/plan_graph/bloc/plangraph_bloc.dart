import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

part 'plangraph_event.dart';
part 'plangraph_state.dart';

class PlangraphBloc extends Bloc<PlangraphEvent, PlangraphState> {
  PlangraphBloc() : super(PlangraphLoading()) {
    on<LoadPlangraph>((event, emit) async {
      // Simulate a delay or fetch graph data here
      await Future.delayed(Duration(seconds: 1));

      // Example graph data points
      final List<FlSpot> graphData = [
        FlSpot(0, 10),
        FlSpot(5, 50),
        FlSpot(10, 100),
        FlSpot(15, 150),
        FlSpot(20, 200),
        FlSpot(25, 300),
        FlSpot(31, 350),
      ];

      emit(PlangraphLoaded(graphData: graphData));
    });
  }
}
