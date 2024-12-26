// BLoC class for review page
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_event.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';

class ReviewPageBloc extends Bloc<ReviewPageEvent, ReviewPageState> {
  Logger logger = new Logger();
  ReviewPageBloc() : super(ReviewPageLoaded(
        subPlan: '',
        selectedDate: null,
        selectedOption: '',
        noofStables: '',
        noofHorse: '',
        noofEvents: '',
      )) {
    on<AddUserTenant>((event, emit) async {
      try {
        var tenantId = await cacheService.getString(name: 'tenantId');
        var userId = await cacheService.getString(name: 'userId');
        Map data={
          "tenant": {
            "plan": {
              "id":  event.plan
            },
            "paymentModel": {
              "id": event.selectedSubscription
            },
            "user": {
              "id": userId
            },
            "subEnddate": "2024-08-30",
            "subStartdate": "2024-07-01",
            "subStatus": "active",
            "status": "active",
            "horsecount": event.noofHorse,
            "stablecount": event.noofStables,
            "eventcount": event.noofEvents,
            "tenantName" : event.name
          }
        };
        logger.d(data);

        final response = await tenantrepo.postTenant(data:data);

        if (response.statusCode == 200 && response.error.isEmpty) {
          logger.d("Added tenant success");
          emit(AddTenantSuccess());
        } else {
          emit(AddTenantFailed(error: response.message));
        }
      }  catch (error) {
        // try {
        //   // Simulate a delay for form submission
        //   await Future.delayed(Duration(seconds: 2));
        //   emit(AddStableSuccess());
        // } catch (error) {
        emit(AddTenantFailed(error: error.toString()));
      }

    });
  }

  @override
  Stream<ReviewPageState> mapEventToState(ReviewPageEvent event) async* {
    if (event is LoadReviewPage) {
      yield ReviewPageLoaded(
        subPlan: event.subPlan,
        selectedDate: event.selectedDate,
        selectedOption: event.selectedOption,
        noofStables: event.noofStables,
        noofHorse: event.noofHorse,
        noofEvents: event.noofEvents,
      );
    }
  }
}