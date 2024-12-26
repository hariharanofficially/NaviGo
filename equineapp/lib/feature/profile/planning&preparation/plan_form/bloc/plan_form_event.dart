part of 'plan_form_bloc.dart';

sealed class PlanFormEvent extends Equatable {
  const PlanFormEvent();

  @override
  List<Object> get props => [];
}

class LoadPlanForm extends PlanFormEvent {
  // final this. id;
  const LoadPlanForm();
  @override
  List<Object> get props => [];
}

class SubmitFormPlan extends PlanFormEvent {

  final String horseId;
  final String planStartDate;
  final String planEndDate;
  final String bodyweight;
  final String walk;
  final String trot;
  final String canter;
  final String gallop;
  final String foreShoeTypeId;
  final String foreShoeSpecificationId;
  final String foreShoeComplementId;
  final String hindShoeTypeId;
  final String hindShoeSpecificationId;
  final String hindShoeComplementId;

  final List<Map<String, dynamic>> treatments; // Accepting list of treatments
  final List<Map<String, dynamic>> nutritions; // Accepting list of nutritions
  final List<Map<String, dynamic>> bloodTest;
  SubmitFormPlan({
    required this.horseId,
    required this.planStartDate,
    required this.planEndDate,
    required this.bodyweight,
    required this.walk,
    required this.trot,
    required this.canter,
    required this.gallop,
    required this.foreShoeTypeId,
    required this.foreShoeSpecificationId,
    required this.foreShoeComplementId,
    required this.hindShoeTypeId,
    required this.hindShoeSpecificationId,
    required this.hindShoeComplementId,

    required this.treatments,
    required this.nutritions,
    required this.bloodTest,
  });
}
