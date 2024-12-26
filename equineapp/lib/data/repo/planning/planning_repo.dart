import '../../models/api_response.dart';
import '../../models/planning_model.dart';

abstract class PlanningRepo {
  Future<ApiResponse> addplanning({

    required String horseId,
    required String planStartDate,
    required String planEndDate,
    required String bodyweight,
    required String walk,
    required String trot,
    required String canter,
    required String gallop,
    required String foreShoeTypeId,
    required String foreShoeSpecificationId,
    required String foreShoeComplementId,
    required String hindShoeTypeId,
    required String hindShoeSpecificationId,
    required String hindShoeComplementId,

    required List<Map<String, dynamic>>
        treatments, // Accepting list of treatments
    required List<Map<String, dynamic>>
        nutritions, // Accepting list of nutritions
    required List<Map<String, dynamic>> bloodTests,
  });
  Future<List<PlanningModel>> getAllPlanning({required String horseId});
}
