import 'dart:convert';

import 'package:EquineApp/data/repo/bloodtest/bloodtest_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/bloodtest_type.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/repo/repo.dart';

part 'blood_form_view_event.dart';
part 'blood_form_view_state.dart';

class BloodFormViewBloc extends Bloc<BloodFormViewEvent, BloodFormViewState> {
  Logger logger = new Logger();
  BloodFormViewBloc() : super(BloodFormInitial()) {
    on<LoadBloodFormView>((event, emit) async {
      emit(BloodFormViewLoading());
      try {
        final response = await Bloodtestrepo.getBloodTestHorseTenantResult(
            horseId: event.horseId, testDate: event.testDate);
        var responseData = jsonDecode(response.data.toString());
        logger.d(responseData.toString());

        // Extract test date and test type from the response
        String testDate = responseData['bloodTests'][0]['testDatetime'];
        String bloodTestType =
            responseData['bloodTests'][0]['bloodTestType']['name'];

        // Filter bloodTestElements based on category (BIOCHEMISTRY / HAEMATOLOGY)
        List<BloodTestElement> bioChemistryTests = [];
        List<BloodTestElement> hematologyTests = [];

        // Iterate over the bloodTests and filter them based on category
        List<BloodTestElement> bloodTestElements =
            responseData['bloodTests'].map<BloodTestElement>((test) {
          // Create the BloodTestElement object from the response
          return BloodTestElement(
              name: test['bloodTestElement']['name'],
              unit: test['bloodTestElement']['unit'],
              normalRange: test['bloodTestElement']['normalRange'],
              code: test['bloodTestElement']['code'],
              active: test['bloodTestElement']['active'],
              category: test['bloodTestElement']['category'],
              resultValue: test['resultValue'].toString());
        }).toList();

        // Now filter bioChemistryTests and hematologyTests based on the category
        bioChemistryTests = bloodTestElements
            .where(
                (test) => test.category.toUpperCase().trim() == 'BIOCHEMISTRY')
            .toList();

        hematologyTests = bloodTestElements
            .where(
                (test) => test.category.toUpperCase().trim() == 'HAEMATOLOGY')
            .toList();

        // Emit the state with filtered test data
        emit(BloodFormViewLoaded(
            testDate: testDate,
            bloodTestType: bloodTestType,
            bioChemistryTests: bioChemistryTests,
            hematologyTests: hematologyTests));
      } catch (e) {
        logger.d(e.toString());
        emit(BloodFormViewFailed(error: e.toString()));
      }
    });
  }
}
