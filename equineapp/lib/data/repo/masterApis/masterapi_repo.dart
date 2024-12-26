import '../../models/FoodUom_model.dart';
import '../../models/api_response.dart';
import '../../models/bloodtest_type.dart';
import '../../models/shoeSpecification.dart';
import '../../models/shoeType_model.dart';
import '../../models/shoecomplement.dart';
import '../../models/surfaceType.dart';
import '../../models/trainingType.dart';
import '../../models/treatment_type.dart';
import '../../models/foodType_model.dart';
import '../../models/bloodtest_element.dart';

abstract class MasterApiRepo {
  //Trainingtype
  Future<ApiResponse> addTrainingType({required String name});
  Future<ApiResponse> updateTrainingType(
      {required int id, required String name});
  Future<List<TrainingType>> getAllTrainingTypes();
  Future<void> deleteTrainingTypes({required int id});

  //Surfacetype
  Future<ApiResponse> addSurfaceType({required String name});
  Future<ApiResponse> updateSurfaceType(
      {required int id, required String name});
  Future<List<SurfaceType>> getAllSurfaceTypes();
  Future<void> deleteSurfaceTypes({required int id});

  //Bloodtestelement
  Future<List<BloodTestElement>> getAllBloodTestElement();
  //Bloodtestype
  Future<ApiResponse> addBloodTestType({required String name});
  Future<ApiResponse> updateBloodTestType(
      {required int id, required String name});
  Future<List<BloodTestType>> getAllBloodTestTypes();
  Future<void> deleteBloodTestTypes({required int id});

  //Treatmenttype
  Future<ApiResponse> addTreatmentType({required String name});
  Future<ApiResponse> updateTreatmentType(
      {required int id, required String name});
  Future<List<TreatmentType>> getAllTreatmentType();
  Future<void> deleteTreatmentType({required int id});

  //foodtype
  Future<ApiResponse> addFoodType(
      {required String name, required String descripition});
  Future<ApiResponse> updateFoodType(
      {required int id, required String name, required String descripition});
  Future<List<FoodType>> getAllFoodType();
  Future<void> deleteFoodType({required int id});

  //fooduomtype
  Future<ApiResponse> addFoodUomType({required String name});
  Future<ApiResponse> updateFoodUomType(
      {required int id, required String name});
  Future<List<FoodUomType>> getAllFoodUom();
  Future<void> deleteFoodUom({required int id});

  //shoetype
  Future<ApiResponse> addshoeType({required String name});
  Future<ApiResponse> updateshoeType({required int id, required String name});
  Future<List<shoeType>> getAllshoeType();
  Future<void> deleteshoeType({required int id});

  //shoespecf
  Future<ApiResponse> addshoeSpecification({required String name});
  Future<ApiResponse> updateshoeSpecification(
      {required int id, required String name});
  Future<List<shoeSpecification>> getAllshoeSpecification();
  Future<void> deleteshoeSpecification({required int id});

  //shoecomp
  Future<ApiResponse> addshoeComplement({required String name});
  Future<ApiResponse> updateshoeComplement(
      {required int id, required String name});
  Future<List<shoeComplement>> getAllshoeComplement();
  Future<void> deleteshoeComplement({required int id});
}
