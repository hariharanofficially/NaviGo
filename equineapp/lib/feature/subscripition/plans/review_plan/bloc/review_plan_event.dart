// Define events for the review page
abstract class ReviewPageEvent {}

class LoadReviewPage extends ReviewPageEvent {
  final String subPlan;
  final DateTime? selectedDate;
  final String selectedOption;
  final String noofStables;
  final String noofHorse;
  final String noofEvents;

  LoadReviewPage({
    required this.subPlan,
    required this.selectedDate,
    required this.selectedOption,
    required this.noofStables,
    required this.noofHorse,
    required this.noofEvents,
  });
}

class AddUserTenant extends ReviewPageEvent {
  final String name;
  final String plan;
  final String selectedSubscription;
  final String noofStables;
  final String noofHorse;
  final String noofEvents;
  AddUserTenant({
    required this.name,
    required this.plan,
    required this.selectedSubscription,
    required this.noofStables,
    required this.noofHorse,
    required this.noofEvents,
  });
}