import '../../models/api_response.dart';
import '../../models/treatment_model.dart';

abstract class TreatmentRepo {
  Future<ApiResponse> addtreatment({
    required String horseId,
    required String notes,
    required String treatmentDatetime,
    required String nextCheckupDatetime,
    required String treatmenttypeid,
  });
  Future<ApiResponse> updatetreatment({
    required int id,
    required String horseId,
    required String notes,
    required String treatmentDatetime,
    required String nextCheckupDatetime,
    required String treatmenttypeid,
  });
  Future<List<TreatmentModel>> getAllTreament();
  Future<TreatmentModel> getAllTreamentById({required int id});
  Future<void> deletetreatment({required int id});
}
