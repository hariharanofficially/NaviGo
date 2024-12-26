part of 'blood_form_view_bloc.dart';

sealed class BloodFormViewState extends Equatable {
  const BloodFormViewState();

  @override
  List<Object> get props => [];
}

final class BloodFormInitial extends BloodFormViewState {}

class BloodFormViewLoading extends BloodFormViewState {}

class BloodFormViewLoaded extends BloodFormViewState {
  final String testDate;
  final String bloodTestType;
  final List<BloodTestElement> bioChemistryTests;
  final List<BloodTestElement> hematologyTests;

  BloodFormViewLoaded({
    required this.testDate,
    required this.bloodTestType,
    required this.bioChemistryTests,
    required this.hematologyTests,
  });

  @override
  List<Object> get props =>
      [testDate, bloodTestType, bioChemistryTests, hematologyTests];
}

// class BloodFormViewLoaded extends BloodFormViewState {
//   final String testDate;
//   final String bloodTestType;
//   final List<BloodTestElement> bloodTestElement;

//   BloodFormViewLoaded(
//       {required this.testDate,
//       required this.bloodTestType,
//       required this.bloodTestElement,
//       });
// }

class BloodFormViewFailed extends BloodFormViewState {
  final String error;

  BloodFormViewFailed({required this.error});
}
