part of 'nutrition_bloc.dart';

sealed class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object> get props => [];
}

class LoadNutrition extends NutritionEvent {
  // final String id;
  const LoadNutrition();
  @override
  List<Object> get props => [];
}

class DeleteNutrition extends NutritionEvent {
  final int nutritionId;

  DeleteNutrition({required this.nutritionId});
}
