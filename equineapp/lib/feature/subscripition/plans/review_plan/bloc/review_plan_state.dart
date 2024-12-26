// Define states for the review page
abstract class ReviewPageState {}

class ReviewPageLoaded extends ReviewPageState {
  final String subPlan;
  final DateTime? selectedDate;
  final String selectedOption;
  final String noofStables;
  final String noofHorse;
  final String noofEvents;

  ReviewPageLoaded({
    required this.subPlan,
    required this.selectedDate,
    required this.selectedOption,
    required this.noofStables,
    required this.noofHorse,
    required this.noofEvents,
  });
}

class AddTenantSuccess extends ReviewPageState {}

class AddTenantFailed extends ReviewPageState {
  final String error;
  AddTenantFailed( {
    required this.error
  });
}
