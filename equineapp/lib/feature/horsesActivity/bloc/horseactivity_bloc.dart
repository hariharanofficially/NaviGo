import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'horsesactivity_event.dart';
part 'horsesactivity_state.dart';

class horseactivitybloc extends Bloc<HorsesactivityEvent, HorsesactivityState> {
  horseactivitybloc() : super(HorsesactivityLoading()) {
    on<LoadHorsesactivity>((event, emit) async {
      try {
        // Fetch data or perform necessary operations
        final data1 = await fetchDataForDaily();
        final data2 = await fetchDataForWeekly();
        final data3 = await fetchDataForMonthly();

        emit(HorsesactivityLoaded(
          horsesactivity1: data1,
          horsesactivity2: data2,
          horsesactivity3: data3,
        ));
      } catch (e) {
        emit(HorsesactivityError('Failed to load data'));
      }
    });
  }
  Future<dynamic> fetchDataForDaily() async {
    // Replace with actual data-fetching logic
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return []; // Return the actual data
  }

  Future<dynamic> fetchDataForWeekly() async {
    // Replace with actual data-fetching logic
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return []; // Return the actual data
  }

  Future<dynamic> fetchDataForMonthly() async {
    // Replace with actual data-fetching logic
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return []; // Return the actual data
  }
}
