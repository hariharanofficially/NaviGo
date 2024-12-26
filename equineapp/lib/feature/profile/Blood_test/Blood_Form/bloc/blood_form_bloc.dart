import 'package:EquineApp/data/repo/bloodtest/bloodtest_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/bloodtest_result.dart';
import '../../../../../data/models/bloodtest_type.dart';

import '../../../../../data/models/horse_model.dart';
import '../../../../../data/repo/repo.dart';

part 'blood_form_event.dart';
part 'blood_form_state.dart';

class BloodFormBloc extends Bloc<BloodFormEvent, BloodFormState> {
  BloodFormBloc() : super(BloodFormInitial()) {
    on<SubmitFormBlood>((event, emit) async {
      try {
        final response = event.id != null
            ? await Bloodtestrepo.updatebloodtest(
                id: event.id!,
                horseId: event.horseId,
                BloodtestElementId: event.BloodtestElementId,
                BloodtestTypeId: event.BloodtestTypeId,
                dateOfBirth: event.dateOfBirth,
                result: event.result,
              )
            : await Bloodtestrepo.addbloodtest(
                horseId: event.horseId,
                BloodtestElementId: event.BloodtestElementId,
                BloodtestTypeId: event.BloodtestTypeId,
                dateOfBirth: event.dateOfBirth,
                result: event.result,
              );
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(BloodtestFormSuccessfully(message: response.message));
        } else {
          emit(BloodFormFailure(error: response.message));
        }
      } catch (e) {
        emit(BloodFormFailure(error: e.toString()));
      }
    });
    on<LoadBloodform>((event, emit) async {
      emit(BloodFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(BloodFormLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(BloodFormerror(message: e.toString()));
      }
    });

    on<LoadBloodTestResultsById>((event, emit) async {
      emit(BloodFormLoading()); // Emit loading state
      try {
        // Fetch dropdown data (if needed for other fields)
        final allFormData = await dropdownRepo.getAllFormData();

        // Fetch blood test results by ID
        BloodTestResult bloodTestResults =
            await Bloodtestrepo.getBloodTestResultsbyId(id: event.id);

        // Assuming the response contains blood test details to add to allFormData
        allFormData.bloodtestDetails =
            bloodTestResults; // Update based on your response structure

        emit(BloodFormLoaded(
            allFormModel: allFormData)); // Emit the loaded state
      } catch (e) {
        emit(BloodFormerror(message: e.toString())); // Emit an error state
      }
    });

    on<SubmitBloodTestType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateBloodTestType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addBloodTestType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<BloodTestType> types = await masterApiRepo.getAllBloodTestTypes();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(BloodTestTypeCreateSuccess(types: types));
        } else {
          emit(BloodTestTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(BloodTestTypeCreateFailed(error: e.toString()));
      }
    });
    on<DeleteBloodTestType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteBloodTestTypes(id: event.BloodTestTypeId);

        // Reload the BloodTestType after deletion
        List<BloodTestType> types = await masterApiRepo.getAllBloodTestTypes();
        emit(BloodTestTypeDeleted(types: types));
      } catch (e) {
        emit(BloodFormerror(message: e.toString()));
      }
    });
  }
}
