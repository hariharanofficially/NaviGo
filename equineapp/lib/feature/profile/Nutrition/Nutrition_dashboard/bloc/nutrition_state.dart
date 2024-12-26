part of 'nutrition_bloc.dart';

sealed class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object> get props => [];
}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final List<Map<String, Object>> nutritions;

  const NutritionLoaded({required this.nutritions});

  @override
  List<Object> get props => [nutritions];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object> get props => [message];
}

class NutritionDeleted extends NutritionState {}
