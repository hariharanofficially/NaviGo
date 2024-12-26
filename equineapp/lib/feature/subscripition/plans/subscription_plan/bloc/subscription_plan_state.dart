// States
import '../../../../../data/models/SubPlanComponent_model.dart';
import '../../../../../data/models/SubscriptionPlans_model.dart';
import '../../../../../data/models/paymentmodel.dart';

abstract class SubscriptionState {}

class InitialSubscriptionState extends SubscriptionState {}

final class SubscriptionSuccessState extends SubscriptionState {
  final List<SubscriptionPlansModel> plans;
  SubscriptionSuccessState({
    required this.plans});
}

class SubscriptionFailureState extends SubscriptionState {
  final String message;

  SubscriptionFailureState({required this.message});
}

final class SubscriptionComponentSuccessState extends SubscriptionState {
  final int planId;
  final String planName;
  final int defaultHorsesCount;
  final int maxHorsesCount;
  final int defaultStableCount;
  final int maxStableCount;
  final int defaultEventCount;
  final int maxEventCount;

  SubscriptionComponentSuccessState({
    required this.planId,
    required this.planName,
    required this.defaultHorsesCount,
    required this.maxHorsesCount,
    required this.defaultStableCount,
    required this.maxStableCount,
    required this.defaultEventCount,
    required this.maxEventCount,
  });
}

final class SubscriptionPaymentsSuccessState extends SubscriptionState {
  final int planId;
  final String planName;
  final List<Paymentmodel> paymentmodes;
  SubscriptionPaymentsSuccessState({
    required this.planId,
    required this.planName,
    required this.paymentmodes});
}

class SubscriptionComponentFailureState extends SubscriptionState {
  final String message;
  SubscriptionComponentFailureState({required this.message});
}

class SubscriptionPaymentsFailureState extends SubscriptionState {
  final String message;
  SubscriptionPaymentsFailureState({required this.message});
}
