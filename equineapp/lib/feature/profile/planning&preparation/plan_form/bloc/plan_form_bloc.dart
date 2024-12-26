import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/repo/repo.dart';

part 'plan_form_event.dart';
part 'plan_form_state.dart';

class PlanFormBloc extends Bloc<PlanFormEvent, PlanFormState> {
  Logger logger = new Logger();
  PlanFormBloc() : super(PlanFormInitial()) {
    on<SubmitFormPlan>((event, emit) async {
      try {
        final response = await planningrepo.addplanning(
          horseId: event.horseId,
          planStartDate: event.planStartDate,
          planEndDate: event.planEndDate,
          bodyweight: event.bodyweight,
          walk: event.walk,
          trot: event.trot,
          canter: event.canter,
          gallop: event.gallop,
          foreShoeTypeId: event.foreShoeTypeId,
          foreShoeSpecificationId: event.foreShoeSpecificationId,
          foreShoeComplementId: event.foreShoeComplementId,
          hindShoeTypeId: event.hindShoeTypeId,
          hindShoeSpecificationId: event.hindShoeSpecificationId,
          hindShoeComplementId: event.hindShoeComplementId,

          treatments: event.treatments,
          nutritions: event.nutritions,
          bloodTests: event.bloodTest,
        );
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(PlanFormSuccessfully(message: response.message));
        } else {
          emit(PlanFormerror(error: response.message));
        }
      } catch (e) {
        emit(PlanFormerror(error: e.toString()));
      }
    });
    on<LoadPlanForm>((event, emit) async {
      emit(PlanFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(PlanFormLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(PlanFormerror(error: e.toString()));
      }
    });
  }
}
