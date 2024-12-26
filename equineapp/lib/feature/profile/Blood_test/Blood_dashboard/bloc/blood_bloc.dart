import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../../../data/models/bloodtest_result.dart';
import '../../../../../data/repo/repo.dart';

part 'blood_event.dart';
part 'blood_state.dart';

class BloodBloc extends Bloc<BloodEvent, BloodState> {
  Logger logger = new Logger();

  BloodBloc() : super(BloodLoading()) {
    on<LoadBlood>((event, emit) async {

        try {
          final response = await Bloodtestrepo.getBloodTestResults(
            horseId: event.horseId
          );
          if (response.statusCode == 200 && response.error.isEmpty) {
            var data = jsonDecode(response.data.toString());
            final List<BloodTestResult> bloodtest = (data['bloodTests'] as List)
                .map((e) => BloodTestResult.fromJson(e))
                .toList();

            emit(BloodLoaded(blood: bloodtest));
          } else {
            //logger.e(e.toString());
            emit(BloodError("Failed to load horses"));
          }
        } catch (e) {
          logger.e(e.toString());
          emit(BloodError("Failed to load horses"));
        }


    });

    // Handle the DeleteHorse event
    on<DeleteBloodTest>((event, emit) async {
      try {
        // Call the delete API
        await Bloodtestrepo.deleteBloodTestById(id:event.id);

        // Reload the horses after deletion
        // final horses = await riderrepo.getAllRider();
        emit(BloodTestDeleted());
      } catch (e) {
        emit(BloodTestDeleted());
      }
    });
  }
}
