import '../../models/api_response.dart';
import '../../models/nutrition_model.dart';

abstract class NutritionRepo {
  Future<ApiResponse> addNutrition({
    required String nutritionDatetime,
    required String horseId,
    required String foodType,
    required String feeduom,
    required String servingValue,
  });
  Future<ApiResponse> updateNutrition({
    required int id,
    required String nutritionDatetime,
    required String horseId,
    required String foodType,
    required String feeduom,
    required String servingValue,
  });
  Future<List<NutritionModel>> getAllNutrition();
  Future<NutritionModel> getAllNutritionById({required int id});
  Future<void> deletenutrition({required int id});
}
