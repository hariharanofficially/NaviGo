import '../../models/api_response.dart';
import '../../models/bloodtest_result.dart';

abstract class bloodtestrepo {
  Future<ApiResponse> addbloodtest({
    required String horseId,
    required String dateOfBirth,
    required String BloodtestElementId,
    required String BloodtestTypeId,
    required String result,
  });
  Future<ApiResponse> updatebloodtest({
    required int id,
    required String horseId,
    required String dateOfBirth,
    required String BloodtestElementId,
    required String BloodtestTypeId,
    required String result,
  });

  Future<ApiResponse> getBloodTestResults({required String horseId});
  Future<BloodTestResult> getBloodTestResultsbyId({
    required int id,
  });

  Future<ApiResponse> getBloodTestHorseTenantResult(
      {required String horseId, required String testDate});

  Future<void> deleteBloodTestById({required String id});
}
