import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../data/models/planning_model.dart';
import '../../../../../utils/mixins/convert_date_format.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc() : super(PlanLoading()) {
    on<LoadPlanning>((event, emit) async {
      try {
        // Fetching planning data
        List<PlanningModel> planningList =
            await planningrepo.getAllPlanning(horseId: event.horseId);

        List<Map<String, dynamic>> planningData = planningList
            .map((planning) {
              // Format the dates from the model (assuming startDate and endDate are DateTime objects)
              String startDateFormatted = formatDate(planning.planStartDate);
              String endDateFormatted = formatDate(planning.planEndDate);
              return [
                {
                  'planning': 'Summary',
                  'percentage': '20.0',
                  'color': Color(0xFFA3F5FB),
                  'startDate': startDateFormatted,
                  'endDate': endDateFormatted,
                },
                {
                  'planning': 'Body Measurement',
                  'percentage': planning.bodyWeight, // A double for percentage
                  'color': Color(0xFFFFC8C8), // Color for this item
                  // 'startDate': startDateFormatted,
                  // 'endDate': endDateFormatted,
                },
                {
                  'planning': 'Training',
                  'percentage': planning.totalTraining, // Another percentage
                  'color': Color(0xFFC8FFDE), // Color for this item
                },
                {
                  'planning': 'Treatment',
                  'percentage': planning.treatments != null
                      ? 50.5
                      : 0.0, // Another percentage
                  'color': Color(0xFFA3F5FB), // Color for this item
                },
                {
                  'planning': 'Nutrition',
                  'percentage': planning.nutritions != null
                      ? 50.5
                      : 0.0, // Another percentage
                  'color': Color(0xFFBCC3FF), // Color for this item
                },
                {
                  'planning': 'Farrier',
                  'percentage': 50.5, // Another percentage
                  'color': Color(0xFFFFBBF0), // Color for this item
                },
              ];
            })
            .expand((element) => element)
            .toList(); // Flatten the list
        emit(PlanLoaded(planning: planningData));
      } catch (e) {
        emit(PlanError("Failed to Load Planning"));
      }
    });
  }
}
