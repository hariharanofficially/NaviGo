// Events
abstract class SubscriptionEvent {}

class PlanSelectedEvent extends SubscriptionEvent {
  final String planType;

  PlanSelectedEvent(this.planType);
}

class ValidateFormEvent extends SubscriptionEvent {}

class PlanInitialEvent extends SubscriptionEvent {}

class SelectedSubscriptionEvent extends SubscriptionEvent {
  final int planId;
  final String planName;
  SelectedSubscriptionEvent({required this.planId, required this.planName});
}

class GetSubscriptionPaymentModeEvent extends SubscriptionEvent {
  final String name;
  final int planId;
  final String planName;
  final String noOfEvents;
  final String noOfStables;
  final String noOfHorses;
  GetSubscriptionPaymentModeEvent({
    required this.name,
    required this.planId,
    required this.planName,
    required this.noOfEvents,
    required this.noOfStables,
    required this.noOfHorses});
}
