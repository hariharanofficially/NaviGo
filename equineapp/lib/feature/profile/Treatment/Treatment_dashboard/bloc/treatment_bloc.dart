import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/treatment_model.dart';
import '../../../../../data/service/service.dart';

part 'treatment_event.dart';
part 'treatment_state.dart';

class TreatmentBloc extends Bloc<TreatmentEvent, TreatmentState> {
  TreatmentBloc() : super(TreatmentLoading()) {
    on<LoadTreatment>((event, emit) async {
      try {
        final List<TreatmentModel> treatments =
            await treatmentrepo.getAllTreament();

        final treatmentData = treatments.map((treatment) {
          String treatmentDate =
              DateFormat('dd-MMM-yy').format(treatment.treatmentDatetime);
          String nextCheckupDate =
              DateFormat('dd MMM yyyy').format(treatment.nextCheckupDatetime);

          return {
            // "Treatment": "Treatment Type" ?? 'Unknown',
            "Treatment2": treatment.treatmentTypeName ?? '',
            "Treatment3": "Next Check-up Date",
            "Treatment4": nextCheckupDate, // Provide a default if null
            "TreatmentDate": treatmentDate,
            "treatmentId": treatment.id.toString(),
          } as Map<String, Object>; // Cast to Map<String, Object>
        }).toList();
        // final Treatment = [
        //   {
        //     "Treatment": "Treatment Type",
        //     "Treatment2": "Vaccination",
        //     "Treatment3": "Next Check-up Date",
        //     "Treatment4": "25-Sept-2024"
        //   },
        // ];
        emit(TreatmentLoaded(Treatment: treatmentData));
      } catch (e) {
        emit(TreatmentError("Failed to load Treatment"));
      }
    });
    on<DeleteTreatment>((event, emit) async {
      try {
        // Delete the treatment using the repository
        await treatmentrepo.deletetreatment(id: event.treatmentId);

        // // Reload treatments after deletion
        // final List<TreatmentModel> treatments =
        //     await treatmentrepo.getAllTreament();

        // // Format the updated treatment data
        // final treatmentData = treatments.map((treatment) {
        //   String treatmentDate =
        //       DateFormat('d\'th\' MMMM').format(treatment.treatmentDatetime);
        //   String nextCheckupDate = treatment.nextCheckupDatetime != null
        //       ? DateFormat('dd MMM yyyy').format(treatment.nextCheckupDatetime!)
        //       : 'N/A';

        //   return {
        //     "Treatment": "Treatment Type",
        //     "Treatment2": treatment.treatmentTypeName ?? 'Unknown',
        //     "Treatment3": "Next Check-up Date",
        //     "Treatment4": nextCheckupDate,
        //     "TreatmentDate": treatmentDate,
        //     "treatmentId": treatment.id.toString(),
        //   };
        // }).toList();

        emit(TreatmentDeleted());
      } catch (e) {
        emit(TreatmentDeleted());
      }
    });
  }
}
