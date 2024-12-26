// Bloc
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_event.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/SubPlanComponent_model.dart';
import '../../../../../data/models/SubscriptionPlans_model.dart';
import '../../../../../data/models/paymentmodel.dart';
import '../../../../../data/repo/repo.dart';
import 'package:logger/logger.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  Logger logger = new Logger();

  SubscriptionBloc() : super(InitialSubscriptionState()) {
    on<PlanInitialEvent>((event, emit) async {
      logger.d("%@%@%@%@@% called planinitialevent %@%@%@%@@% ");
      await _getAllPlans(event, emit);
    });
    on<SelectedSubscriptionEvent>((event, emit) async {
      logger.d("%@%@%@%@@% called SelectedSubscriptionEvent %@%@%@%@@% ");
      await _getPlanComponents(event, emit);
    });
    on<GetSubscriptionPaymentModeEvent>((event, emit) async {
      logger.d("%@%@%@%@@% called GetSubscriptionPaymentModeEvent %@%@%@%@@% ");
      await _getPaymentModes(event, emit);
    });

  }

  Future<void> _getAllPlans (
      PlanInitialEvent event,
      Emitter<SubscriptionState> emit,
      ) async {
    try {
      //emit(SigninSubmittingState());
      logger.d("%@%@%@%@%@ inside get all plans %@%@%@%@%%@");
      List<SubscriptionPlansModel> response = await subPlanRepo.getAllSubplan();
      logger.d(response.toString());
      emit(SubscriptionSuccessState(plans: response));

    } catch (e) {
      logger.d("%@%@%@%@%@ " + e.toString() + " %@%@%@%@%%@");
      emit(SubscriptionFailureState(message: "Could not get all plans"));
    }
  }

  Future<void> _getPlanComponents (
      SelectedSubscriptionEvent event,
      Emitter<SubscriptionState> emit,
      ) async {
    try {
      //emit(SigninSubmittingState());
      logger.d("%@%@%@%@%@ inside get all plans %@%@%@%@%%@");
      List<SubPlanComponentModel> response = await subPlanComponentRepo.getAllSubPlanComponent(id: event.planId);
      logger.d(response.toString());

      int defaultHorsesCount = 0;
      int maxHorsesCount = 0;
      int defaultStableCount = 0;
      int maxStableCount = 0;
      int defaultEventCount = 0;
      int maxEventCount = 0;

      response.forEach( (planComponent) {
        if (planComponent.name == "stables") {
          defaultStableCount = int.parse(planComponent.defaultcount);
          maxStableCount = int.parse(planComponent.maxcount);
        } else if (planComponent.name == "horses") {
          defaultHorsesCount = int.parse(planComponent.defaultcount);
          maxHorsesCount = int.parse(planComponent.maxcount);
        }  else if (planComponent.name == "horses") {
          defaultEventCount = int.parse(planComponent.defaultcount);
          maxEventCount = int.parse(planComponent.maxcount);
        }
      });

      emit(SubscriptionComponentSuccessState(
          planId: event.planId,
          planName: event.planName,
          defaultHorsesCount: defaultHorsesCount,
          maxHorsesCount : maxHorsesCount,
          defaultStableCount : defaultStableCount,
          maxStableCount : maxStableCount,
          defaultEventCount: defaultEventCount,
          maxEventCount : maxEventCount
      ));

    } catch (e) {
      logger.d("%@%@%@%@%@ " + e.toString() + " %@%@%@%@%%@");
      emit(SubscriptionComponentFailureState(message: "Could not get all plans components"));
    }
  }

  Future<void> _getPaymentModes (
      GetSubscriptionPaymentModeEvent event,
      Emitter<SubscriptionState> emit,
      ) async {
    try {
      //emit(SigninSubmittingState());
      logger.d("%@%@%@%@%@ inside get all payment modes %@%@%@%@%%@");
      List<Paymentmodel> response = await paymentrepo.getAllPayment();
      logger.d(response.toString());
      emit(SubscriptionPaymentsSuccessState(
          planId: event.planId,
          planName: event.planName,
          paymentmodes: response));

    } catch (e) {
      logger.d("%@%@%@%@%@ " + e.toString() + " %@%@%@%@%%@");
      emit(SubscriptionPaymentsFailureState(message: "Could not get all plans components"));
    }
  }

  // @override
  // Stream<SubscriptionState> mapEventToState(SubscriptionEvent event) async* {
  //   if (event is PlanSelectedEvent) {
  //     yield SubscriptionSuccessState(plans: "Plan selected: ${event.planType}");
  //   } else if (event is ValidateFormEvent) {
  //     // Add validation logic here if needed
  //     yield SubscriptionFailureState("Validation error: Please enter details.");
  //   }
  // }
}